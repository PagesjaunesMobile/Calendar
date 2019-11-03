/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation

// MARK: - CalendarPeriodFormater

/// Protocol, define the morning and the afternoon name.
/// Required to implement a method wich evaluate
/// if the date passed in parameter is morning of afternoon.
public protocol CalendarPeriodFormater {

  // MARK: Public properties

  /// Monring name text
  var morningName: String { get }

  /// AfterNoon name text
  var afternoonName: String { get }

  // MARK: Public methods

  /// Evaluate if the date passed in parameter is afternoon or morning
  func isAfternoon(date: Date) -> Bool
}
