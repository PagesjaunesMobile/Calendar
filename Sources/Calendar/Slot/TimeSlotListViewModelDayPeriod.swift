/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation

extension TimeSlotListViewModel {

  // MARK: DayPeriod

  /// Represent the DayPeriod (morning or afternoon)
  ///
  /// - morning: represent morning day period
  /// - afternoon: represent afternoon day period
  enum DayPeriod: Equatable {

    // MARK: Case

    case morning(periodName: String)
    case afternoon(periodName: String)

    // MARK: Public computed property

    /// Evaluate if the current period is morning
    var isMorning: Bool {
      switch self {
      case .morning(periodName: _):
        return true
      case .afternoon(periodName: _):
        return false
      }
    }

    /// Evaluate if the current day period is afternoon
    var isAfternoon: Bool {
      switch self {
      case .morning(periodName: _):
        return false
      case .afternoon(periodName: _):
        return true
      }
    }

    /// Return the current day period name
    var periodName: String {
      switch self {
      case .morning(periodName: let periodName):
        return periodName
      case .afternoon(periodName: let periodName):
        return periodName
      }
    }
  }
}

// MARK: Equatable

extension TimeSlotListViewModel.DayPeriod {
  static func == (lhs: TimeSlotListViewModel.DayPeriod, rhs: TimeSlotListViewModel.DayPeriod) -> Bool {
    switch (lhs, rhs) {
    case (.morning, .morning):
      return true
    case (.afternoon, .afternoon):
      return true
    case (.morning, .afternoon):
      return false
    case (.afternoon, .morning):
      return false
    }
  }
}
