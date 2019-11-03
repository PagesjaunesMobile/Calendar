import XCTest
import UIKit
@testable import CalendarUI

final class CalendarUITests: XCTestCase {
    func testDataController() {
      let dataProvider = MockDataProvider()
      let dataController = CalendarDataController(dataProvider: dataProvider,
                                                  periodFormater: DefaultCalendarPeriodFormater(),
                                                  locale: Locale(identifier: "fr_FR"))

      XCTAssert(dataController.initialLoadingState.value == .loading, "initialLoadingState should be ready")

      let stateReadyExpectation = XCTestExpectation(description: "initial state ready")
      let stateLoadingExpectation = XCTestExpectation(description: "initial state loading")
      let daysExpectation = XCTestExpectation(description: "days")

      dataController.initialLoadingState.bind { _, value  in
        if value == .loading {
          stateLoadingExpectation.fulfill()
        }
        if value == .ready {
          stateReadyExpectation.fulfill()
        }
      }

      XCTAssert(dataController.days.value.isEmpty == true, "Days should be empty")

      dataController.days.bind { _, models in
        if models.isEmpty == false {
          daysExpectation.fulfill()
        }
      }

      dataController.loadData()
      wait(for: [stateReadyExpectation,
                 stateLoadingExpectation,
                 daysExpectation], timeout: 5.0)

      XCTAssert(dataController.lazyLoadingState.value == .ready, "lazyLoadingState should be ready")

      let lazystateNoResult = XCTestExpectation(description: "lazy state noResult")
      let lazystateLoading = XCTestExpectation(description: "lazy state ready")
      let moreDays = XCTestExpectation(description: "more days")

      dataController.lazyLoadingState.bind { _, state in
        if state == .loading {
          lazystateLoading.fulfill()
        }
        if state == .ready{
          lazystateNoResult.fulfill()
        }
      }

      dataController.days.bind { _, days in
        if days.count == 2 {
          moreDays.fulfill()
        }
      }

      dataController.loadNextResult()
      wait(for: [lazystateNoResult, lazystateLoading, moreDays], timeout: 5.0)

      let selectedDayExcpetation = XCTestExpectation(description: "selected day")
      let selectedSlotExcpectaton = XCTestExpectation(description: "selected slot")

      dataController.selectedDay.bind { _ , dayIndex in
        if dayIndex == 0 {
          selectedDayExcpetation.fulfill()
        }
      }

      dataController.updateSelectedDay(day: dataController.days.value.first!)

      dataController.selectedSlot.bind { _, slot in
        if slot == 0 {
          selectedSlotExcpectaton.fulfill()
        }
      }

      _ = dataController.updateSelectedSlot(slot: dataController.days.value.first!.slots.first!)

      wait(for: [selectedDayExcpetation, selectedSlotExcpectaton], timeout: 5.0)
    }

    func testDayViewModel() {
      let dataProvider = MockDataProvider()
      let dataController = CalendarDataController(dataProvider: dataProvider,
                                                  periodFormater: DefaultCalendarPeriodFormater(),
                                                  locale: Locale(identifier: "fr_FR"))

      dataController.loadData()
      let viewModel = DayViewModel(model: dataController.days.value.first!, dataController: dataController)

      XCTAssert(viewModel.dayNumber == "11", "Day number text is invalid")
      XCTAssert(viewModel.dayOfTheWeek == "mer.", "Mardi")
      XCTAssert(viewModel.morningSlots.isEmpty == false, "Some afternoon slot should be present")
    }

    func testMonthViewModel() {
      let dataProvider = MockDataProvider()
      let dataController = CalendarDataController(dataProvider: dataProvider,
                                                  periodFormater: DefaultCalendarPeriodFormater(),
                                                  locale: Locale(identifier: "fr_FR"))

      dataController.loadData()
      let month = MonthViewModel(model: dataController.days.value, dataController: dataController)!

      XCTAssert(month.monthText == "Février", "Month text should be fevrier")
      XCTAssert(month.yearText == "1987", "Year text should be 1987")

      let selectedDayExpectation = XCTestExpectation(description: "Sected day")

      dataController.selectedDay.bind { _, dayIndex in
        selectedDayExpectation.fulfill()
      }

      month.userWantToShowDayOfThisMonth()
      wait(for: [selectedDayExpectation], timeout: 5.0)
    }

    func testSlotViewModel() {
      let dataProvider = MockDataProvider()
      let dataController = CalendarDataController(dataProvider: dataProvider,
                                                  periodFormater: DefaultCalendarPeriodFormater(),
                                                  locale: Locale(identifier: "fr_FR"))

      dataController.loadData()
      let slotViewModel = TimeSlotViewModel(model: dataController.days.value.first!.slots.first!, dataController: dataController)

      XCTAssert(slotViewModel.displayText == "14h00", "diplay text shoud be 14h00")

      let expectation = XCTestExpectation(description: "selectedSlot")

      dataController.selectedSlot.bind { _, selectedSlotIndex in
        if selectedSlotIndex != nil {
          expectation.fulfill()
        }
      }

      _ = dataController.updateSelectedSlot(slot: dataController.days.value.first!.slots.first!)
      wait(for: [expectation], timeout: 5.0)
    }

    static var allTests = [
        ("testDataController", testDataController),
        ("testDayViewModel", testDayViewModel),
        ("testMonthViewModel", testMonthViewModel),
        ("testSlotViewModel", testSlotViewModel)
    ]
}
