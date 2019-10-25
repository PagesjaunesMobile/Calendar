/*
* Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
*
* Unauthorized copying of this file, via any medium is strictly prohibited.
* Proprietary and confidential.
*/

import Foundation

// MARK: - DefaultCalendarPeriodFormater

/// Standard implementation of the protocol `CalendarPeriodFormater`
public struct DefaultCalendarPeriodFormater: CalendarPeriodFormater {

  // MARK: Public properties

  /// Default morning name implementation
  public var morningName: String = "Matin"

  /// Default afternoon name implementation
  public var afternoonName: String = "Après midi"

  // MARK: Public methods

  // Evaluate if the date passed in parameter is afternoon or morning ( > 03h00 pm is afternoon)
  public func isAfternoon(date: Date) -> Bool {
    let dateComp = Calendar.current.component(Calendar.Component.hour, from: date)
    return dateComp >= 15
  }

  public init() {

  }

}

