/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation

extension CalendarDataController {

  /// Store all requiered data formater in order to create `DayDataControllerModel` ans `SlotDataControllerModel`.
  /// `DateFormatter` instanciation and usage are EXTREMELY CPU CONSUMING !!!.
  /// The CalendarDateFormater shouln't be used eleswhere than by the `CalendarDataController`
  /// who will instanciate the `CalendarDateFormater` just once, and will use those method only on background queue.
  struct CalendarDateFormater {

    /// Custom locale, provide by the `CalendarDataController`
    private let locale: Locale

    /// DateFormater configured to return
    /// the Month in complete text version ("Janvier")
    /// the locale property will be used
    private let monthExtractor: DateFormatter

    /// DateFormater configured to return
    /// the year in digit text version ("2019")
    /// the locale property will be used
    private let yearExtractor: DateFormatter

    /// DateFormater configured to return
    /// the day in digit text version ("23")
    /// the locale property will be used
    private let dayExtractor: DateFormatter

    /// DateFormater configured to return
    /// the day of the week in text version ("Lundi")
    /// the locale property will be used
    private let dayOfWeekExtractor: DateFormatter

    /// DateFormater configured to return
    /// hours and minutes in the text version ("23:00")
    /// the locale property will be used
    private let hoursMinutesExtractor: DateFormatter

    /// Instanciate the `CalendarDateFormater`, `CalendarDataController`
    /// should be the only one to instanciate this formater
    /// - Parameter locale: locale parameter, provided by the `CalendarDataController`
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

    /// Month text from date (Janvier)
    /// - Parameter date: date to process
    func extractMonth(date: Date) -> String {
      self.monthExtractor.string(from: date)
    }

    /// Year text from date (2019)
    /// - Parameter date: date to process
    func extractYear(date: Date) -> String {
      self.yearExtractor.string(from: date)
    }

    /// Month day text from date (23)
    /// - Parameter date: date to process
    func extractDay(date: Date) -> String {
      self.dayExtractor.string(from: date)
    }

    /// Week day text from date (23)
    /// - Parameter date: date to process
    func exctractDayOfWeek(date: Date) -> String {
      self.dayOfWeekExtractor.string(from: date)
    }

    /// Extract hours and minutes text (23:00)
    /// - Parameter date: date to process
    func extractHoursAndMinutes(date: Date) -> String {
      self.hoursMinutesExtractor.string(from: date)
    }

  }
}
