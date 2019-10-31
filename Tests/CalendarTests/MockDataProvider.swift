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

  let dayFormater: DateFormatter = {
    let dest = DateFormatter()
    dest.locale = Locale(identifier: "fr_FR")
    dest.dateFormat = "dd MM yyyy"
    return dest
  }()

  let slotFormater: DateFormatter = {
    let dest = DateFormatter()
    dest.locale = Locale(identifier: "fr_FR")
    dest.dateFormat = "dd MM yyyy HH:mm"
    return dest
  }()

  func loadData(completion: @escaping (CalendarDataProviderResult) -> Void) {

    let date = self.dayFormater.date(from: "11 02 1987")! // C'est mon anniversaire tu va faire quoi ???
    let dateSlot = self.slotFormater.date(from: "11 02 1987 14:00")!

    let slot1 = SlotDataProviderModel(originalDate: dateSlot, code: dateSlot.description)
    
    let model = DayDataProviderModel(originalDate: date, slots: [slot1])
    completion(.success(days: [model]))
  }

  func loadNextResult(fromDate date: Date, completion: @escaping (CalendarDataProviderResult) -> Void) {

    guard self.complete == false else {
      completion(.noResult)
      return
    }

    let nextDate = self.dayFormater.date(from: "12 02 1987")! // C'est mon anniversaire tu va faire quoi ???
    let nextDateSlot = self.slotFormater.date(from: "12 02 1987 14:00")!

    let slot1 = SlotDataProviderModel(originalDate: nextDateSlot, code: nextDateSlot.description)
    let model = DayDataProviderModel(originalDate: nextDate, slots: [slot1])
    completion(.success(days: [model]))
    self.complete = true
  }
}
