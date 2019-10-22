/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation

public protocol CalendarPeriodFormater {
  var morningName: String { get }
  var afternoonName: String { get }
  func isAfternoon(date: Date) -> Bool
}
