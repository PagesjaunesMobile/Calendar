/*
* Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
*
* Unauthorized copying of this file, via any medium is strictly prohibited.
* Proprietary and confidential.
*/

import Foundation

public struct DefaultCalendarPeriodFormater: CalendarPeriodFormater {
  public var morningName: String = "Matin"
  public var afternoonName: String = "Après midi"

  public func isAfternoon(date: Date) -> Bool {
    let dateComp = Calendar.current.component(Calendar.Component.hour, from: date)
    return dateComp >= 15
  }

  public init() {

  }

}

