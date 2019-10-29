/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation

// MARK: - DayViewModel

/// Design to work with `DaySelectorCell`, and `TimeSlotListViewModel`
/// Provide display information, and Slot viewModels, handle also user actions
class DayViewModel {

  // MARK: Private properties

  /// `CalendarDataController` Model representation
  private let originalModel: DayDataControllerModel

  /// Share `CalendarDataController` accross all ViewModel of `CallendarViewController`
  private let dataController: CalendarDataController

  /// all slots viewModel contain in this day
  private let slotsViewModel: [TimeSlotViewModel]

  /// MARK: Public properties

  /// Text representation of the day in the week (Jeu.)
  let dayOfTheWeek: String

  /// Day number in the month (28)
  let dayNumber: String

  /// Accessibility text representation
  let accessibilityValue: String

  // MARK: Public methods

  // MARK: Slots accessors

  /// Return a `DayViewModel` which correspond to the first previous day with some slots
  ///
  /// - Returns: a `DayViewModel` which represent the previous day with some slots
  func getFirstDayWithSlotBeforeThisDay() -> DayViewModel? {
    guard let model = self.dataController.getFirstDayWithSlot(before: self.originalModel) else { return nil }
    return DayViewModel(model: model, dataController: dataController)
  }

  /// Return a `DayViewModel` which correspond to the first next day with some slots
  ///
  /// - Returns: a `DayViewModel` which represent the first next day with some slots
  func getNextDayWithSlotAfterThisDay() -> DayViewModel? {
    guard let model = self.dataController.getFirstDayWithSlot(after: self.originalModel) else { return nil }
    return DayViewModel(model: model, dataController: dataController)
  }

  /// Return the first alviable slot
  var firstSlot: TimeSlotViewModel? {
    return self.slotsViewModel.first
  }

  /// All day slots which are in the morning period (the final evaluation is made by the `CalendarPeriodFormater` in the `CalendarDataController`)
  /// Usefull in `UICollectionViewDataSource` `cellForItemAt"
  var morningSlots: [TimeSlotViewModel] {
    return self.slotsViewModel.filter { $0.isAfternoon == false }
  }

  /// All day slots which are in the afternoon period (the final evaluation is made by the `CalendarPeriodFormater` in the `CalendarDataController`)
  /// Usefull in `UICollectionViewDataSource` `cellForItemAt"
  var afternoonSlots: [TimeSlotViewModel] {
    return self.slotsViewModel.filter { $0.isAfternoon == true }
  }

  /// Return if the current day containt some slots
  var noSlotAlviable: Bool {
    return self.slotsViewModel.isEmpty
  }

  // MARK: Handle user actions

  /// Handle user action, notify the `CalendateDataController` to select this day
  func userWantToShowSlotOfThisDay() {
    self.dataController.updateSelectedDay(day: self.originalModel)
  }

  // MARK: Init

  /// Create the ViewModel representation of a `DayDataControllerModel`
  ///
  /// - Parameters:
  ///   - model: `CalendarDataController` model
  ///   - dataController: shared `CalendarDataController` accros all `CalendarViewController` viewModels
  init(model: DayDataControllerModel, dataController: CalendarDataController) {
    self.originalModel = model
    self.dayOfTheWeek = model.shortDayText
    self.accessibilityValue = model.realDate.description

    self.dayNumber = model.dayNumberText
    self.slotsViewModel = self.originalModel.slots.map { TimeSlotViewModel(model: $0, dataController: dataController) }
    self.dataController = dataController

    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
      // if one slot is selected, all other slots are unselected
      self.slotsViewModel.forEach { slot in
        slot.isSelected.bind(observer: { [weak self] _, isSelected in
          guard let `self` = self, isSelected == true else { return }
          self.slotsViewModel.filter { elem in
            elem != slot
          }.forEach { $0.unSelect() }
        })
      }
    }
  }
}

// MARK: - Equatable

extension DayViewModel: Equatable {
  static func == (lhs: DayViewModel, rhs: DayViewModel) -> Bool {
    return lhs.originalModel == rhs.originalModel
  }
}
