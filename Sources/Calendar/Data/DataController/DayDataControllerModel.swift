/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation

// MARK: - DayDataControllerModel

/// Represent a Day in the `CalendarDataController`,
/// it's build from a `DayDataProviderModel` day.
struct DayDataControllerModel: Equatable, Hashable {

  /// Store all `SlotDataControllerModel` available in the day
  var slots: [SlotDataControllerModel]

  /// French month representation ("Fevrier")
  let monthText: String

  /// Text year representation ("2019")
  let yearText: String

  /// Short French representation of the day of the week ("Jeu.")
  let shortDayText: String

  /// Text day position in the month ("23")
  let dayNumberText: String

  /// Date of the day
  let realDate: Date

  /// Init of DayDataControllerModel from a `DayDataProviderModel`
  ///
  /// - Parameter day: day returned by a `CalendarDataProvider` concrete instance
  init(day: DayDataProviderModel, formater: CalendarDataController.CalendarDateFormater) {

    self.realDate = day.originalDate

    self.monthText = formater.extractMonth(date: day.originalDate)
    self.yearText = formater.extractYear(date: day.originalDate)
    self.dayNumberText = formater.extractDay(date: day.originalDate)
    self.shortDayText = formater.exctractDayOfWeek(date: day.originalDate)

    self.slots = day.slots.map { SlotDataControllerModel(model: $0, formater: formater) }
  }
}

// MARK: - Equatable

extension DayDataControllerModel {
  static func == (lhs: DayDataControllerModel, rhs: DayDataControllerModel) -> Bool {
    if lhs.realDate == rhs.realDate { return true }
    return false
  }
}

// MARK: - Comparable

extension DayDataControllerModel: Comparable {
  static func < (lhs: DayDataControllerModel, rhs: DayDataControllerModel) -> Bool {
    return lhs.realDate < rhs.realDate
  }
}

// MARK: - Hashable

extension DayDataControllerModel {
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.realDate)
  }
}
