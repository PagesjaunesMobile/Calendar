/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation

// MARK: MonthViewModel

/// designed to work with `MonthCell`,
/// provide display information and handle user actions
class MonthViewModel {

  // MARK: Private properties

  /// Corresponding DayDayaControllerModel
  private let originalModels: [DayDataControllerModel]

  /// DataController, shared with all viewModel
  private let dataController: CalendarDataController

  // MARK: Public properties

  /// Month name (Fevrier)
  let monthText: String

  /// Year text to display (2019)
  let yearText: String

  // MARK: Public methods

  /// ViewModel init
  ///
  /// - Parameters:
  ///   - model: `CalendarDataController` models
  ///   - dataController: shared dataController
  init?(model: [DayDataControllerModel], dataController: CalendarDataController) {
    self.originalModels = model
    guard let first = model.first else { return nil }
    self.monthText = first.monthText.capitalized
    guard let year =  model.first?.yearText else { return nil }
    self.yearText = year
    self.dataController = dataController
  }

  /// Determine if the day passed in parameter is contain in the viewModel month
  ///
  /// - Parameter day: day to test
  /// - Returns: true if it contain false if not
  func dayIsContainInThisMonth(day: DayDataControllerModel) -> Bool {
    return self.originalModels.contains(day)
  }

  /// Handle user action when the user want to display days of this month
  func userWantToShowDayOfThisMonth() {
    guard let first = self.originalModels.first else { return }
    self.dataController.updateSelectedDay(day: first)
  }

  /// Return an array of `MonthViewModel` from an array of `DayDataControllerModel`
  ///
  /// - Parameters:
  ///   - daysModel: input days
  ///   - datacontroller: required to instanciate any Calendar ViewModel
  /// - Returns: an array of `MonthViewModel`
  static func getMonthsViewModelFrom(daysModel: [DayDataControllerModel], datacontroller: CalendarDataController) -> [MonthViewModel] {

    var months = [MonthViewModel]()

    var dest = [String: [DayDataControllerModel]]()

    for aDay in daysModel {
      if var tab = dest[aDay.monthText + aDay.yearText] {
        tab.append(aDay)
        dest[aDay.monthText + aDay.yearText] = tab
      } else {
        dest[aDay.monthText + aDay.yearText] = [aDay]
      }
    }

    for (_, value) in dest {
      if let month = MonthViewModel(model: value, dataController: datacontroller) {
        months.append(month)
      }
    }

    months.sort { return $0 < $1 }
    return months
  }
}

// MARK: - Equatable

extension MonthViewModel: Equatable {
  static func == (lhs: MonthViewModel, rhs: MonthViewModel) -> Bool {
    return lhs.originalModels == rhs.originalModels
  }
}

// MARK: - Comparable

extension MonthViewModel: Comparable {

  static func < (lhs: MonthViewModel, rhs: MonthViewModel) -> Bool {
    guard let firstLeft = lhs.originalModels.first, let firstRight = rhs.originalModels.first else { return false }
    return firstLeft < firstRight
  }
}
