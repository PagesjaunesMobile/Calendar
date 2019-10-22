/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation

// MARK: - DisplayState

extension TimeSlotListViewModel {

  /// Represent the Slot collectionView display state
  ///
  /// - notReady: Data are not loaded yet
  /// - timeSlot: There is some slots to display
  /// - timeSlotEmpty: Data are ready but there is no slot to displayq
  enum DisplayState {

    // MARK: Case

    case notReady
    case timeSlot(day: DayViewModel, period: DayPeriod, slot: TimeSlotViewModel?)
    case timeSlotEmpty(previousDayWithSlot: DayViewModel?, nextDayWithSlot: DayViewModel?)

    // MARK: Computed public properties

    /// Return the selected period
    var periode: DayPeriod? {
      switch self {
      case .notReady:
        return nil
      case .timeSlot(day: _, period: let period, slot: _):
        return period
      case .timeSlotEmpty(previousDayWithSlot: _, nextDayWithSlot: _):
        return nil
      }
    }

    /// Return the Slot according to the selected day and period
    ///
    /// - Parameter index: slot index
    /// - Returns: Slot viewModel according to the index,
    /// the selected day, and the selected period
    func slotForCurrentDayAndPeriod(index: Int) -> TimeSlotViewModel? {
      switch self {
      case .timeSlot(day: let day, period: let period, slot: _):
        switch period {
        case .morning:
          guard index >= 0, index < day.morningSlots.count else { return nil }
          return day.morningSlots[index]
        case .afternoon:
          guard index >= 0, index < day.afternoonSlots.count else { return nil }
          return day.afternoonSlots[index]
        }
      case .notReady:
        return nil
      case .timeSlotEmpty:
        return nil
      }
    }

    /// Return the segmented control period index 0 for morning, 1 for afternoon
    var segmentedControllPeriodIndex: Int {
      switch self {
      case .timeSlot(day: _, period: let period, slot: _):
        switch period {
        case .morning:
          return 0
        case .afternoon:
          return 1
        }
      case .notReady:
        return 0
      case .timeSlotEmpty:
        return 0
      }
    }

    /// Compute the element count to display in the `UICollectionView`
    /// if there is some slots it's the number of slots, if not it's 1 because
    /// the NoSlotCell cell should be presented
    /// if the display state is notReady there is 0 element to display.
    var itemCount: Int {
      switch self {
      case .notReady:
        return 0
      case .timeSlot(day: let day, period: let period, slot:_):
        switch period {
        case .afternoon:
          return day.afternoonSlots.count
        case .morning:
          return day.morningSlots.count
        }
      case .timeSlotEmpty:
        return 1
      }
    }

    /// Return the Slot ViewModel according to the given index, selected day and period
    ///
    /// - Parameter index: given index
    subscript(index: Int) -> TimeSlotViewModel? {
      switch self {
      case .timeSlot(day: let day, period: let timePeriod, slot: _):
        switch timePeriod {
        case .morning:
          if index >= 0 && index < day.morningSlots.count {
            return day.morningSlots[index]
          } else { return nil }
        case .afternoon:
          if index >= 0 && index < day.afternoonSlots.count {
            return day.afternoonSlots[index]
          } else { return nil }
        }
      case .timeSlotEmpty:
        return nil
      case .notReady:
        return nil
      }
    }
  }
}
