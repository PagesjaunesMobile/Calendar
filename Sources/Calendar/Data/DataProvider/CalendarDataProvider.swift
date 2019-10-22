/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation

/// MARK: - CalendarDataProvider

/// Protocol to implement in order to provide Date and slot to `CalendarViewController`
protocol CalendarDataProvider {

  /// This method will be used in the initial loading,
  /// it should provide an array of `DayDataProviderModel` with some `SlotDataProviderModel` inside
  ///
  /// - Parameter completion: completion closure
  func loadData(completion: @escaping (CalendarDataProviderResult) -> Void)

  /// This method will be used during lazy loading process,
  /// it should provide an array of `DayDataProviderModel` with some `SlotDataProviderModel` inside
  ///
  /// - Parameter date: start point date, returned date should be after this date
  /// - Parameter completion: completion closure
  func loadNextResult(fromDate date: Date, completion: @escaping (CalendarDataProviderResult) -> Void)
}

// MARK: - CalendarDataProviderResult

/// loadData / loadNextResult completion parameter
///
/// - success: Some days have been loaded, the loading process is a success
/// - noResult: There is no problem, but there is 0 result
/// - error: Some error occured
enum CalendarDataProviderResult {
  case success(days: [DayDataProviderModel])
  case noResult
  case error
}

// MARK: - SlotDataProviderModel

/// Slot `CalendarDataProvider` model,
/// should provide a Date and a code.
struct SlotDataProviderModel {
  let originalDate: Date
  let code: String
}

/// MARK: - DayDataProviderModel

/// Day `CalendarDataProvider` model,
/// should provide a Date and an array of `SlotDataProviderModel`.
struct DayDataProviderModel {
  let originalDate: Date
  var slots: [SlotDataProviderModel]
}
