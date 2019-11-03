/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation

// MARK: - DisplaySate

extension NoSlotCellViewModel {

  /// Describe the display mode of the view with
  /// only the previous slot, only the next slots or both
  ///
  /// - oneSlotPrevious: The view should display just previous slot
  /// - oneSlotNext: The view should display just the next slot
  /// - twoSlot: the view should display previous and next day slots
  enum DisplaySate {

    // MARK: Case

    case oneSlotPrevious(day: DayViewModel)
    case oneSlotNext(day: DayViewModel)
    case twoSlot(previous: DayViewModel, next: DayViewModel)

    // MARK: Init

    /// Display State init with a previous and or a next `DayViewModel`
    /// if both next and previous are nil the init will fail
    ///
    /// - Parameters:
    ///   - previousDay: previous day with slots
    ///   - nextDay: next day with slots
    init?(previousDay: DayViewModel?, nextDay: DayViewModel?) {
      if let previousDay = previousDay, nextDay == nil {
        self = .oneSlotPrevious(day: previousDay)
      } else if let nextDay = nextDay, previousDay == nil {
        self = .oneSlotNext(day: nextDay)
      } else if let previousDay = previousDay, let nextDay = nextDay {
        self = .twoSlot(previous: previousDay, next: nextDay)
      } else {
        return nil
      }
    }
  }

}

// MARK: - NoSlotCellViewModel

/// Designed to work with `NoSlotCell`
/// Priovide display information and handle user actions
class NoSlotCellViewModel {

  // MARK: Private properties

  /// Describe the display mode of the view,
  /// one previous slot, one next slot or both
  private let displayState: DisplaySate

  // MARK: Public computed property

  /// Indicate if the view should present only one previous slot
  var shouldPresentOnePreviousDay: Bool {
    switch  self.displayState {
    case .oneSlotPrevious:
      return true
    case .oneSlotNext:
      return false
    case .twoSlot:
      return false
    }
  }

  /// Indicate if the view should present only one next slot
  var shouldPresentOneNextDay: Bool {
    switch  self.displayState {
    case .oneSlotPrevious:
      return false
    case .oneSlotNext:
      return true
    case .twoSlot:
      return false
    }
  }

  /// Indicate if the view should present previous and next slot
  var shouldPresentPreviousAndNextDay: Bool {
    switch  self.displayState {
    case .oneSlotPrevious:
      return false
    case .oneSlotNext:
      return false
    case .twoSlot:
      return true
    }
  }

  /// Previous `DayViewModel` to display, the first slot will be used
  var previousDay: DayViewModel? {
    switch self.displayState {
    case .oneSlotNext:
      return nil
    case .oneSlotPrevious(day: let previousDay):
      return previousDay
    case .twoSlot(previous: let previousDay, next: _):
      return previousDay
    }
  }

  /// Next `DayViewModel` to display, the first slot will be used
  var nextDay: DayViewModel? {
    switch self.displayState {
    case .oneSlotNext(day: let next):
      return next
    case .oneSlotPrevious:
      return nil
    case .twoSlot(previous: _, next: let next):
      return next
    }
  }

  // MARK: Public methods

  func userDidTapOnPreviousDay() {
    guard let previousDay = self.previousDay else { return }
    previousDay.userWantToShowSlotOfThisDay()

  }

  func userDidTapOnNextDay() {
    guard let nextDay = self.nextDay else { return }
    nextDay.userWantToShowSlotOfThisDay()
  }

  // MARK: Init

  /// Init `NoSlotCell` ViewModel with a previous and / or a nextDay
  /// if both are nil, init will fail
  ///
  /// - Parameters:
  ///   - previousDay: previous day with slot to display (could be nil il the nexDay parameter is not nil)
  ///   - nextDay: next day with slot to display (could be nil il the previous parameter is not nil)
  ///   - dataController: shared `CalendarDataController` accross all `CalendarViewController` viewModels
  init?(previousDay: DayViewModel?, nextDay: DayViewModel?, dataController: CalendarDataController) {
    guard let displayState = DisplaySate(previousDay: previousDay, nextDay: nextDay) else { return nil }
    self.displayState = displayState
  }

}
