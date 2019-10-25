/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation

// MARK: - LoadingState

extension CalendarDataController {
  enum LoadingState {
    case ready
    case loading
    case error
    case noResult
  }
}

// MARK: - CalendarDataController

/// Central point of the `CalendarViewController` architecture, centralized the Data information:
/// - Loaded Days and Slots
/// - Selected Day
/// - Selected Slot
/// - initial loading status
/// - lazy loading status
///
/// Thoses properties are observable.
///
/// Public methods: `updateSelectedDay` and `updateSelectedSlot` allow to modify the selection
/// `loadData` and `loadNextResult` will load days and slot from the `CalendarDataProvider`
/// and will update the observable property days.
class CalendarDataController {

  // MARK: Public Observable properties

  /// Dispatch queue for model mapping and the heavy Date processing asynchronously
  private let calendarQueue = DispatchQueue(label: "CalendarDispatchQueue", qos: DispatchQoS.userInteractive)

  /// Provide initial data loading state information
  private(set) var initialLoadingState = CalendarObservable<LoadingState>(.loading)

  /// Provide lazy loading data loading state information
  private(set) var lazyLoadingState = CalendarObservable<LoadingState>(.ready)

  /// Loaded days, filled by `loadData` and `loadNextResult` method
  private(set) var days: CalendarObservable<[DayDataControllerModel]> = CalendarObservable<[DayDataControllerModel]>([])

  /// Selected day Index updated by `updateSelectedDay` method
  private(set) var selectedDay: CalendarObservable<Int> = CalendarObservable<Int>(0)

  /// Selected slot Index updated by `updateSelectedSlot` method
  private(set) var selectedSlot: CalendarObservable<Int?> = CalendarObservable<Int?>(nil)

  // MARK: Public Computed properties

  /// Convenience computed property, return the selected `DayDataControllerModel`
  /// according to the `selectedDay` value
  var selectedDayModel: DayDataControllerModel? {
    guard selectedDay.value >= 0, selectedDay.value < self.days.value.count else { return nil }
    return self.days.value[self.selectedDay.value]
  }

  /// Convenience computed property, return the selected `SlotDataControllerModel`
  /// according to the `selectedSlot` value
  var selectedSlotModel: SlotDataControllerModel? {
    guard let selectedDay = self.selectedDayModel else { return nil }
    guard let selectedSlot = self.selectedSlot.value else { return nil }
    guard selectedSlot >= 0, selectedSlot < selectedDay.slots.count else { return nil }
    return selectedDay.slots[selectedSlot]
  }

  /// Return the morning period name according to the period formater
  var morningName: String {
    return self.periodFormater.morningName
  }

  /// Return the afternoon period name according to the period formater
  var afternoonName: String {
    return self.periodFormater.afternoonName
  }

  // MARK: Private properties

  /// Store the some DateFormater required to create `CalendarDateFormater` models
  private let dateFormater: CalendarDateFormater

  /// Period formater used to determine the name of the mornig / afternoon period and how it's determined
  private let periodFormater: CalendarPeriodFormater

  /// Provide Day and slot data, used in `loadData` and `loadNexResult`
  private let dataProvider: CalendarDataProvider

  // MARK: Public methods

  /// Update the `selectedDay` value, if the day passed
  /// in parameter is contain in the `days` array.
  ///
  /// if the selected day is superior to the half of the loaded days count,
  /// `loadNextResult` is performed
  /// `selectedSlot` is set to nil if the `selectedDay` value change
  ///
  /// - Parameter day: day to select
  func updateSelectedDay(day: DayDataControllerModel) {
    if let dest = self.days.value.firstIndex(of: day) {
      self.selectedDay.value = Int(dest)
      self.selectedSlot.value = nil
      if selectedDay.value >= (self.days.value.count / 2) {
        self.loadNextResult()
      }
    }
  }

  /// Update the `selectedSlot` value,
  /// if the selectedSlot is contain in the selected day
  ///
  /// - Parameter slot: slot to select
  /// - Returns: true if the slot selection succeed
  func updateSelectedSlot(slot: SlotDataControllerModel) -> Bool {
    guard let day = self.selectedDayModel else {
      self.selectedSlot.value = nil
      return false
    }
    guard let index = day.slots.firstIndex(of: slot) else {
      self.selectedSlot.value = nil
      return false
    }
    self.selectedSlot.value = Int(index)
    return true
  }

  /// Get first with slot alviable before this day
  ///
  /// - Parameter day: day to compare
  /// - Returns: a day before the day passed in parameter with some slots
  func getFirstDayWithSlot(before day: DayDataControllerModel) -> DayDataControllerModel? {
    return self.days.value.filter { ($0 < day) && $0.slots.isEmpty == false }.last
  }

  /// Get first with slot alviable after this day
  ///
  /// - Parameter day: day to compare
  /// - Returns: a day after the day passed in parameter with some slots
  func getFirstDayWithSlot(after day: DayDataControllerModel) -> DayDataControllerModel? {
    return self.days.value.filter { ($0 > day) && $0.slots.isEmpty == false }.first
  }

  /// First call to perfom after register observable properties.
  ///
  /// This method will use the `CalendarDataProvider` to get some days
  /// and will transorm them to `DayDataControllerModel` and will store it in the
  /// `days` property
  /// the value of `initialLoadingState` will be updated
  func loadData() {
    self.initialLoadingState.value = .loading
    self.dataProvider.loadData { [weak self] result in
      guard let `self` = self else { return }
      switch result {
      case .success(days: let model):
        self.initialLoadingState.value = .ready
        self.days.value = model.map { DayDataControllerModel(day: $0, dateFormater: self.dateFormater, periodFormater: self.periodFormater) }
        self.selectedDay.value = 0
      case .error:
        self.initialLoadingState.value = .error
      case .noResult:
        self.initialLoadingState.value = .noResult
      }
    }
  }

  /// This method will be called automatically when the `selectedDay`
  /// is superior to the half of the days array count or could be called from outisde of the controller.
  ///
  /// This method will use the `CalendarDataProvider` to update the `days` array with some new `days`
  /// The last loaded day will be used to request some new days to the `CalendarDataProvider`
  /// Like loadData, day from `CalendarDataProvider` will be transform in `DayDataControllerModel` and added to existant days.
  ///
  /// the value of `lazyLoadingState` will be updated
  func loadNextResult() {

    guard let lastDate = self.days.value.last?.realDate,
      (self.lazyLoadingState.value == .ready || self.lazyLoadingState.value == .error)
      else { return }

    self.lazyLoadingState.value = .loading

    self.dataProvider.loadNextResult(fromDate: lastDate) { [weak self] result in
      guard let `self` = self else { return }
      switch result {
      case .success(days: let model):
        self.calendarQueue.async {
          let newsDay = self.days.value + model.map { DayDataControllerModel(day: $0,
                                                                             dateFormater: self.dateFormater,
                                                                             periodFormater: self.periodFormater) }
          let uniqueDay = Array(Set(newsDay))
          let sorted = uniqueDay.sorted()
          DispatchQueue.main.async {
            self.days.value = sorted
            self.lazyLoadingState.value = .ready
          }
        }
      case .error:
        self.lazyLoadingState.value = .error
      case .noResult:
        self.lazyLoadingState.value = .noResult
      }
    }
  }

  // MARK: Init

  /// Init of `CalendarDataController`,
  /// required 2 dependencies injections, the `CalendarDataProvider` to retrive data from an unknow source and
  /// `CalendarPeriodFormater` in order to format "Matin / Apres midi" from outside the `CalendarDataController`
  ///
  /// - Parameters:
  ///   - dataProvider: concrete implentation of `CalendarDataProvider`
  ///   - periodFormater: concrete implentation of `CalendarPeriodFormater`
  init(dataProvider: CalendarDataProvider, periodFormater: CalendarPeriodFormater, locale: Locale) {
    self.dataProvider = dataProvider
    self.periodFormater = periodFormater
    self.dateFormater = CalendarDateFormater(locale: locale)
  }

}
