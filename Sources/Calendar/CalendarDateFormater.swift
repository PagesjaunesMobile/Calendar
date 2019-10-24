/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation

extension CalendarDataController {

  struct CalendarDateFormater {

    private let locale: Locale

    let monthExtractor: DateFormatter
    let yearExtractor: DateFormatter
    let dayExtractor: DateFormatter
    let dayOfWeekExtractor: DateFormatter

    init(locale: Locale) {
      self.locale = locale
      
      let month = DateFormatter()
      month.locale = locale
      month.dateFormat = "MMMM"
      self.monthExtractor = month

      let year = DateFormatter()
      year.locale = locale
      year.dateFormat = "yyyy"
      self.yearExtractor = year

      let day = DateFormatter()
      day.locale = locale
      day.dateFormat = "d"
      self.dayExtractor = day

      let dayOfWeek = DateFormatter()
      day.locale = locale
      dayOfWeek.dateFormat = "E"
      self.dayOfWeekExtractor = dayOfWeek
    }
  }
}
