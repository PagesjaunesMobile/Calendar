/*
* Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
*
* Unauthorized copying of this file, via any medium is strictly prohibited.
* Proprietary and confidential.
*/


import Foundation

extension CalendarViewController {
  struct Configuration {

    let style: CalendarStyle
    let dataProvider: CalendarDataProvider
    let periodFormater: CalendarPeriodFormater
    let locale: Locale
    let shouldUseEffectView: Bool
    let calendarViewControllerDelegate: CalendarViewControllerDelegate?

    init(style: CalendarStyle,
         dataProvider: CalendarDataProvider,
         periodFormater: CalendarPeriodFormater = DefaultCalendarPeriodFormater(),
         locale: Locale = Locale.current,
         shouldUseEffectView: Bool = false,
         calendarViewControllerDelegate: CalendarViewControllerDelegate? = nil) {
      self.dataProvider = dataProvider
      self.periodFormater = periodFormater
      self.locale = locale
      self.shouldUseEffectView = shouldUseEffectView
      self.calendarViewControllerDelegate = calendarViewControllerDelegate
      self.style = style
    }
  }

}
