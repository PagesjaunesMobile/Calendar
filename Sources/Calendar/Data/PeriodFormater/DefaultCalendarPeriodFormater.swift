/*
* Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
*
* Unauthorized copying of this file, via any medium is strictly prohibited.
* Proprietary and confidential.
*/

import Foundation

struct DefaultCalendarPeriodFormater: CalendarPeriodFormater {
  var morningName: String = "Matin"
  var afternoonName: String = "Après midi"

  func isAfternoon(date: Date) -> Bool {
    let dateComp = Calendar.current.component(Calendar.Component.hour, from: date)
    return dateComp >= 15
  }
}

