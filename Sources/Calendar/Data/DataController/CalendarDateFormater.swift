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

    private let monthExtractor: DateFormatter
    private let yearExtractor: DateFormatter
    private let dayExtractor: DateFormatter
    private let dayOfWeekExtractor: DateFormatter
    private let hoursMinutesExtractor: DateFormatter

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
      dayOfWeek.locale = locale
      dayOfWeek.dateFormat = "E"
      self.dayOfWeekExtractor = dayOfWeek

      let hourMinutes = DateFormatter()
      hourMinutes.locale = locale
      hourMinutes.dateFormat = "HH'h'mm"
      self.hoursMinutesExtractor = hourMinutes
    }

    func extractMonth(date: Date) -> String {
      self.monthExtractor.string(from: date)
    }

    func extractYear(date: Date) -> String {
      self.yearExtractor.string(from: date)
    }

    func extractDay(date: Date) -> String {
      self.dayExtractor.string(from: date)
    }

    func exctractDayOfWeek(date: Date) -> String {
      self.dayOfWeekExtractor.string(from: date)
    }

    func extractHoursAndMinutes(date: Date) -> String {
      self.hoursMinutesExtractor.string(from: date)
    }

  }
}
