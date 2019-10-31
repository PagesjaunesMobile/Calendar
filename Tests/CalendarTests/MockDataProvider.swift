//
//  MockDataProvider.swift
//  Calendar
//
//  Created by Nicolas Bellon on 30/10/2019.
//

import Foundation
@testable import Calendar

class MockDataProvider: CalendarDataProvider {

  var complete = false

  func loadData(completion: @escaping (CalendarDataProviderResult) -> Void) {
    let date = Date()

    let slot1 = SlotDataProviderModel(originalDate: date, code: date.description)
    let model = DayDataProviderModel(originalDate: date, slots: [slot1])
    completion(.success(days: [model]))
  }

  func loadNextResult(fromDate date: Date, completion: @escaping (CalendarDataProviderResult) -> Void) {

    guard self.complete == false else {
      completion(.noResult)
      return
    }

    let date = Date()

    let slot1 = SlotDataProviderModel(originalDate: date, code: date.description)
    let model = DayDataProviderModel(originalDate: date, slots: [slot1])
    completion(.success(days: [model]))
    self.complete = true
  }
}
