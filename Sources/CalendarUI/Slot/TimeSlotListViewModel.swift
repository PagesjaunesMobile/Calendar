/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

//swiftlint:disable cyclomatic_complexity

import Foundation

// MARK: - TimeSlotListViewModelDelegate

/// Handle communication between the viewModel and the view,
/// if the viewModel want just send a message without modify a value
/// the delegate will be used otherwise Observable properties will be used
protocol TimeSlotListViewModelDelegate: class {
  func reloadSlots()
}

// MARK: - TimeSlotListViewModel

/// Slot list representation `ViewModel`
/// Indicate how represent Slot in a `UICollectionView`
/// and deal with morning / afternoon header and the noSlot situation
/// Handle user interaction, and rederict those to the `CalendarDataController`
class TimeSlotListViewModel {

  // MARK: Private properties

  /// Shared `CalendarDataController` instance shared accross all `CalendarViewController` viewModel
  private let dataController: CalendarDataController

  /// Represent the current displayState of the view, empty, slots, notReady
  private var displayState: DisplayState {
    didSet {
      self.updateObservable(from: self.displayState)
      if let period = displayState.periode {
        self.lastPeriod = period
      }
    }
  }

  /// Store the last period the user choose in order to not change the selected
  /// period when the user select an other day.
  /// If there is no slot to the period, the other period is automaticaly selected
  private var lastPeriod: DayPeriod

  // MARK: Read only Public properties

  /// Observable property describe the accessibility value to set in the slot collectionView
  private (set) var accessibilitySelectedSlotValue = CalendarObservable<String>("No Slot")

  /// Observable property describe the period to activate in the `SlotheaderCell` segmentedControl.
  private (set) var segmentedControlIndexToDisplay = CalendarObservable<Int>(0)

  // MARK: Public properties

  /// used to reload data when the day change
  weak var delegate: TimeSlotListViewModelDelegate?

  // MARK: Computed Public properties

  /// Describe the morning period, the morning period name is returned by the `CalendarDataController`
  var moringPeriod: DayPeriod {
    return .morning(periodName: self.dataController.morningName)
  }

  /// Describe the afternoon period, the afternoon period name is returned by the `CalendarDataController`
  var afternoonPeriod: DayPeriod {
    return .afternoon(periodName: self.dataController.afternoonName)
  }

  /// Return how much element should be displayed,
  /// handle the NoSlot case and return juste 1 element in order to display the NoSlotCell
  var itemCount: Int {
    return self.displayState.itemCount
  }

  /// Return the section count according to the current display state
  var sectionCount: Int {
    switch self.displayState {
    case .notReady:
      return 1
    case .timeSlot:
      return 2
    case .timeSlotEmpty:
      return 2
    }
  }

  /// Return if the NoSlotCell should be displayed
  /// according to the current displayState
  var shouldDisplayNoSlotCell: Bool {
    switch self.displayState {
    case .notReady:
      return false
    case .timeSlot:
      return false
    case .timeSlotEmpty:
      return true
    }
  }

  /// Return the NoSlotCellViewModel, if it's possible
  /// this method should be called only if `shouldDisplayNoSlotCell` return true
  var noSlotModel: NoSlotCellViewModel? {
    switch self.displayState {
    case .notReady:
      return nil
    case .timeSlot:
      return nil
    case .timeSlotEmpty(previousDayWithSlot: let previousDay, nextDayWithSlot: let nextDay):
      return NoSlotCellViewModel(previousDay: previousDay, nextDay: nextDay, dataController: self.dataController)
    }
  }

  /// Return the Slot ViewModel to configure CalendarSlotCell
  /// according to the given Int
  /// design to be called from the method `cellForItemAt` in `UICollectionViewDataSource`
  ///
  /// - Parameter index: index description
  subscript(index: Int) -> TimeSlotViewModel? {
    return self.displayState[index]
  }

  // MARK: Private methods

  /// Update Observable Value when the displayState is updated, the displayState change when the
  /// dataController Observed value change or when a user action happen
  ///
  /// - Parameter displayState: new display state value
  private func updateObservable(from displayState: DisplayState) {
    switch displayState {
    case .timeSlot(day: _, period: _, slot: let slot):
      if self.segmentedControlIndexToDisplay.value != displayState.segmentedControllPeriodIndex {
        self.segmentedControlIndexToDisplay.value = displayState.segmentedControllPeriodIndex
      }

      guard let slot = slot else { return }
      self.accessibilitySelectedSlotValue.value = slot.displayText
      
    case .timeSlotEmpty(previousDayWithSlot: _, nextDayWithSlot: _):
      self.accessibilitySelectedSlotValue.value = "No Slot"
    case .notReady:
      self.accessibilitySelectedSlotValue.value = "No Slot"
    }
  }

  /// Return the DayPeriod to display
  /// if it's possible the last used period will be returned
  /// but if there is no slots for the last used period, the
  /// period with somes slots will be returned
  ///
  /// - Parameter day: day to evaluate
  /// - Returns: computed Day Period (morning or afternoon)
  private func getPeriod(for day: DayViewModel) -> DayPeriod {
    if day.afternoonSlots.isEmpty {
      return self.moringPeriod
    }

    if day.morningSlots.isEmpty {
      return self.afternoonPeriod
    }

    return self.lastPeriod
  }

  /// Subscribe to Observable Value selectedDay, and selectedSlot on the `CalendarDataController`
  /// and update the display state
  private func setupDataController() {
    self.dataController.selectedDay.bind { [weak self] _, _ in

      guard
        let `self` = self,
        let day = self.dataController.selectedDayModel else { return }

      DispatchQueue.main.async {
        let dayViewModel = DayViewModel(model: day, dataController: self.dataController)

        guard dayViewModel.noSlotAlviable == false else {
          self.displayState = .timeSlotEmpty(
            previousDayWithSlot: dayViewModel.getFirstDayWithSlotBeforeThisDay(),
            nextDayWithSlot: dayViewModel.getNextDayWithSlotAfterThisDay())
          self.delegate?.reloadSlots()
          return
        }

        switch self.displayState {
        case .timeSlot(day: let currentDay, period: _, slot: let slot):
          if dayViewModel != currentDay {
            self.displayState = .timeSlot(day: dayViewModel, period: self.getPeriod(for: dayViewModel), slot: slot)
            self.delegate?.reloadSlots()
          }
        case .timeSlotEmpty:
          self.displayState = .timeSlot(day: dayViewModel, period: self.getPeriod(for: dayViewModel), slot: nil)
          self.delegate?.reloadSlots()

        case .notReady:
          self.displayState = .timeSlot(day: dayViewModel, period: self.getPeriod(for: dayViewModel), slot: nil)
          self.delegate?.reloadSlots()
        }
      }
    }
    self.dataController.selectedSlot.bind { [weak self] _, _ in
      guard let `self` = self else { return }

      DispatchQueue.main.async {
        switch self.displayState {
        case .notReady:
          return
        case .timeSlotEmpty(previousDayWithSlot: _, nextDayWithSlot: _):
          return
        case .timeSlot(day: let day, period: let period, slot: let slot):
          if let timeSlotModel = self.dataController.selectedSlotModel {
            let timeSlotViewModel = TimeSlotViewModel(model: timeSlotModel, dataController: self.dataController)
            if let slot = slot, slot != timeSlotViewModel {
              self.displayState = .timeSlot(day: day, period: period, slot: timeSlotViewModel)
            } else if slot == nil {
              self.displayState = .timeSlot(day: day, period: period, slot: timeSlotViewModel)
            }
          } else if slot != nil {
            self.displayState = .timeSlot(day: day, period: period, slot: nil)
          }
        }
      }
    }
  }

  // MARK: Public methods

  // MARK: User actions methods

  /// Handle user action when the user did select a slot
  ///
  /// - Parameter slotIndexPath: indexPath of the selected slot
  func userDidSelectSlot(slotIndexPath: IndexPath) {
    switch self.displayState {
    case .timeSlot:
      guard let slot = self.displayState.slotForCurrentDayAndPeriod(index: slotIndexPath.item) else { return }
      slot.select()
    case .timeSlotEmpty:
      break
    case .notReady:
      break
    }
  }

  /// Handle user action when the user select the morning period
  /// the displayState is updated and the collectionView is reloaded
  func userDidSelectMoringPeriod() {
    switch self.displayState {
    case .timeSlot(day: let dayViewModel, period: let period, slot: _):
      guard period.isMorning == false else { return }
      self.displayState = .timeSlot(day: dayViewModel, period: self.moringPeriod, slot: nil)
      self.delegate?.reloadSlots()
    case .notReady:
      return
    case .timeSlotEmpty:
      return
    }
  }

  /// Handle user action when the user select the afternoon period
  /// the displayState is updated and the collectionView is reloaded
  func userDidSelectAfternoonPeriod() {
    switch self.displayState {
    case .timeSlot(day: let dayViewModel, period: let period, slot: _):
      guard period.isAfternoon == false else { return }
      self.displayState = .timeSlot(day: dayViewModel, period: self.afternoonPeriod, slot: nil)
      self.delegate?.reloadSlots()
    case .notReady:
      return
    case .timeSlotEmpty:
      self.lastPeriod = self.afternoonPeriod
    }
  }

  // MARK: Init

  /// Init Slot collectionView ViewModel
  ///
  /// - Parameter dataController: shared `CalendarDataController`
  /// accros all `CalendarViewController` viewModel
  init(dataController: CalendarDataController) {
    self.dataController = dataController
    self.displayState = .notReady
    self.lastPeriod = .morning(periodName: dataController.morningName)
    self.setupDataController()
  }
}
