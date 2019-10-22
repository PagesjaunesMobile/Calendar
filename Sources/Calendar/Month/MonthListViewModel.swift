/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

//swiftlint:disable cyclomatic_complexity

import Foundation

// MARK: - MonthListViewModelDelegate

/// Handle communication between the viewModel and the view,
/// if the viewModel want just send a message without modify a value
/// the delegate will be used otherwise Observable properties will be used
protocol MonthListViewModelDelegate: class {
  func shouldReloadMonth()
}

// MARK: - ArrowButtonDisplayState

extension MonthListViewModel {

  /// Represent button state
  ///
  /// - enable: The user can tap the button, and the button state should be enabled
  /// - disabled: The user can't tap the button and the button state should be disabled
  /// - loading: The button is hidden and a spinner is display on top of it
  enum ArrowButtonDisplayState {
    case enable
    case disabled
    case loading
  }
}

// MARK: - DisplayState

extension MonthListViewModel {

  /// Represent the view state
  ///
  /// - notReady: The view is not ready to be displayed
  /// - monthSelected: months are loaded and, one month is selected
  enum DisplayState {

    // MARK: Case

    case notReady
    case monthSelected(monthSelected: Int, months: [MonthViewModel])

    // MARK: Private static methods

    /// Return the index of the month which contain the day passed in parameter
    /// and test it on months array passed in parameter
    ///
    /// - Parameters:
    ///   - day: Day to test
    ///   - months: month array used to perform the test
    /// - Returns: index of the month
    private static func getMonthIndex(for day: DayDataControllerModel, months: [MonthViewModel]) -> Int? {
      if let first = (months.first { $0.dayIsContainInThisMonth(day: day) }) {
        return months.firstIndex(of: first)
      }
      return nil
    }

    // MARK: Public methods

    /// Return the index of the month which contain the day passed in parameter
    ///
    /// - Parameter day: Day to test
    /// - Returns: index of the month
    func getMonthIndexForDay(day: DayDataControllerModel) -> Int? {
      switch self {
      case .monthSelected(monthSelected: _, months: let months):
        return DisplayState.getMonthIndex(for: day, months: months)
      case .notReady:
        return nil
      }
    }

    // MARK: Init

    /// Init DisplayState
    ///
    /// - Parameters:
    ///   - days: `CalendarViewController` days
    ///   - dataController: dataController required to instanciate any viewModel
    init(days: [DayDataControllerModel], dataController: CalendarDataController) {
      let months = MonthViewModel.getMonthsViewModelFrom(daysModel: days, datacontroller: dataController)

      guard months.isEmpty == false else { self = .notReady; return }
      guard
        let selectedDay = dataController.selectedDayModel,
        let index = DisplayState.getMonthIndex(for: selectedDay, months: months) else {
        self = .notReady; return
      }
      self = .monthSelected(monthSelected: index, months: months)
    }
  }
}

// MARK: - MonthListViewModel

/// ViewModel designed to works with `MonthSelectorView`
/// provide observable display information, and user interaction handling.
class MonthListViewModel {

  // MARK: Private properties

  /// Shared dataController instance between all `CalendarViewController` ViewModel
  private let dataController: CalendarDataController

  /// Represent the current display state of the view
  private var displayState: DisplayState {
    didSet {
      self.updateObservableValue()
    }
  }

  // MARK: Public properties

  // MARK: Delegate

  weak var delegate: MonthListViewModelDelegate?

  // MARK: Observable read only properties

  /// Represent the display state of the left button
  private (set) var leftButtonDisplayState = CalendarObservable<ArrowButtonDisplayState>(.disabled)

  /// Represent the display state of the right button
  private (set) var rightButtonDisplayState = CalendarObservable<ArrowButtonDisplayState>(.disabled)

  /// Represent the current indexPath to display
  private (set) var selectedIndexPath = CalendarObservable<IndexPath>(IndexPath(item: 0, section: 0))

  // MARK: Public computed properties

  /// Month count usefull to the `UICollectionViewDataSource`
  var monthsCount: Int {
    switch self.displayState {
    case .monthSelected(monthSelected: _, months: let months):
      return months.count
    case .notReady:
      return 0
    }
  }

  /// Subscript, return the `MonthViewModel`
  /// according to the given indexPath, usefull in the `UICollectionViewDataSource`
  ///
  /// - Parameter index: given indexPath
  subscript (index: IndexPath) -> MonthViewModel? {
    switch self.displayState {
    case .monthSelected(monthSelected: _, months: let months):
      guard index.item >= 0, index.item < months.count else { return nil }
      return months[index.item]
    case .notReady:
      return nil
    }
  }

  // MARK: Private methods

  /// In Order to trig Observable mechanism only
  /// if the value change, the value is set to the Observable
  /// property only if the value is diferent.
  ///
  /// - Parameter state: newValue
  private func updateLeftButtonIfNeeded(state: ArrowButtonDisplayState) {
    if self.leftButtonDisplayState.value != state {
      self.leftButtonDisplayState.value = state
    }
  }
  /// In Order to trig Observable mechanism only
  /// if the value change, the value is set to the Observable
  /// property only if the value is diferent.
  ///
  /// - Parameter state: newValue
  private func updateRightButtonIfNeeded(state: ArrowButtonDisplayState) {
    if self.rightButtonDisplayState.value != state {
      self.rightButtonDisplayState.value = state
    }
  }

  /// When the displayState change, Observable properties are updated
  ///
  /// - Parameters:
  ///   - monthSelectedIndex: selectedMonthIndex
  ///   - months: loadedMonths
  private func updateButtonsObservable(monthSelectedIndex: Int, months: [MonthViewModel]) {

    guard months.isEmpty == false else {
      self.updateLeftButtonIfNeeded(state: .disabled)
      self.updateRightButtonIfNeeded(state: .disabled)
      return
    }

    if monthSelectedIndex == 0 {
      self.updateLeftButtonIfNeeded(state: .disabled)
      self.updateRightButtonIfNeeded(state: .enable)
    }

    if monthSelectedIndex > 0 && monthSelectedIndex < months.count {
      self.updateLeftButtonIfNeeded(state: .enable)
      self.updateRightButtonIfNeeded(state: .enable)
    }

    if monthSelectedIndex == months.count - 1 && self.dataController.lazyLoadingState.value == .loading {
      self.updateRightButtonIfNeeded(state: .loading)
    } else if monthSelectedIndex == months.count - 1 && self.dataController.lazyLoadingState.value == .ready {
      self.dataController.loadNextResult()
      self.updateRightButtonIfNeeded(state: .loading)
    } else if monthSelectedIndex == months.count - 1 {
      self.updateRightButtonIfNeeded(state: .disabled)
    }
  }

  /// When the displayState change, Observable properties are updated
  private func updateObservableValue() {
    switch self.displayState {
    case .monthSelected(monthSelected: let selected, months: let months):
      self.updateButtonsObservable(monthSelectedIndex: selected, months: months)
      let indexPath = IndexPath(item: selected, section: 0)
      if self.selectedIndexPath.value != indexPath {
        self.selectedIndexPath.value = indexPath
      }

    case .notReady:
      break
    }
  }

  /// Subscribe the viewModel to Observable `CalendarViewController` properties
  private func setupDataController() {

    self.dataController.lazyLoadingState.bind { [weak self] _, _ in
      guard let `self` = self else { return }
      DispatchQueue.main.async {
        switch self.displayState {
        case .monthSelected(monthSelected: let monthSelected, months: let months):
          self.updateButtonsObservable(monthSelectedIndex: monthSelected, months: months)
        case .notReady:
          break
        }
      }
    }

    self.dataController.days.bind { [weak self] _, days in
      guard let `self` = self else { return }
      DispatchQueue.main.async {
        switch self.displayState {
        case .notReady:
          self.displayState = DisplayState(days: days, dataController: self.dataController)
          self.delegate?.shouldReloadMonth()
        case .monthSelected(monthSelected: let monthIndex, months: _):
          let months = MonthViewModel.getMonthsViewModelFrom(daysModel: days, datacontroller: self.dataController)
          self.displayState = .monthSelected(monthSelected: monthIndex, months: months)
          self.delegate?.shouldReloadMonth()
        }
      }
    }

    self.dataController.selectedDay.bind { [weak self] _, _ in
      guard let `self` = self else { return }
      DispatchQueue.main.async {
        guard let day = self.dataController.selectedDayModel else { return }
        guard let monthSelected = self.displayState.getMonthIndexForDay(day: day) else { return }
        switch self.displayState {
        case .monthSelected(monthSelected: _, months: let months):
          self.displayState = .monthSelected(monthSelected: monthSelected, months: months)
        case .notReady:
          break
        }
      }
    }
  }

  // MARK: Public methods

  // MARK: User Action handling

  /// Handle action when the user want to see a month at specific indexPath
  /// the corresponding viewModel will notify the `CalendarDataController`
  ///
  /// - Parameter indexPath: indexPath to display
  func userWantToDisplayMonthDay(indexPath: IndexPath) {
    switch self.displayState {
    case .monthSelected(monthSelected: _, months: let months):
      if indexPath.item >= 0 && indexPath.item < months.count {
        months[indexPath.item].userWantToShowDayOfThisMonth()
      }
    case .notReady:
      break
    }
  }

  /// Handle action when the user tap on the right button
  /// the corresponding viewModel month will notify the `CalendarDataController`
  func userWantToDisplayNextMont() {
    switch self.displayState {
    case .monthSelected(monthSelected: _, months: let months):
      guard self.selectedIndexPath.value.item + 1 < months.count else { return }
      self.userWantToDisplayMonthDay(indexPath: IndexPath(item: self.selectedIndexPath.value.item + 1, section: 0))
    case .notReady:
      break
    }
  }

  /// Handle action when the user tap on the left button
  /// the corresponding viewModel month will notify the `CalendarDataController`
  func userWantToDisplayPreviousMonth() {
    guard self.selectedIndexPath.value.item - 1 >= 0 else { return }
    self.userWantToDisplayMonthDay(indexPath: IndexPath(item: self.selectedIndexPath.value.item - 1, section: 0))
  }

  // MARK: Init

  /// Init the `MonthSelectorView` viewModel
  ///
  /// - Parameter dataController: shared `CalendarDataController` accros all `CalendarViewController` viewModels
  init(dataController: CalendarDataController) {
    self.dataController = dataController
    self.displayState = DisplayState(days: self.dataController.days.value, dataController: dataController)
    self.setupDataController()
    self.updateObservableValue()
  }
}
