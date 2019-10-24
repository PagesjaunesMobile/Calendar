/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation

// MARK: - DayListViewModelDelegate

/// Handle communication between the viewModel and the view,
/// if the viewModel want just send a message without modify a value
/// the delegate will be used otherwise Observable properties will be used
protocol DayListViewModelDelegate: class {
  func shouldReloadDays()
}

// MARK: - DisplayState
extension DayListViewModel {

  /// Represent the view state
  ///
  /// - notReady: The view is not ready to be displayed
  /// - daySelected: days are loaded and, one day is selected
  enum DisplayState {

    case notReady
    case daySelected(day: Int, days: [DayViewModel])

    init(days: [DayViewModel], selectedDay: Int = 0) {
      if days.isEmpty == true {
        self = .notReady
      } else {
        self = .daySelected(day: selectedDay, days: days)
      }
    }
  }
}

// MARK: - DayListViewModel

/// ViewModel designed to works with `DaySelectorView`
/// provide observable display information, and user interaction handling.
class DayListViewModel {

  // MARK: Private properties

  /// Shared dataController instance between all `CalendarViewController` ViewModel
  private let dataController: CalendarDataController

  /// Represent the current display state of the view
  private var displayState: DisplayState {
    didSet {
      self.updateObervable(from: self.displayState)
    }
  }

  // MARK: Public properties

  weak var delegate: DayListViewModelDelegate?

  // MARK: Observable read only Public properties

  /// Describe the indexPath to select on the CollectionView
  private (set) var selectedIndexPath = CalendarObservable<IndexPath>(IndexPath.init(row: 0, section: 0))

  // MARK: Computed Public properties

  /// Day count to display usefull in `UICollectionViewDatasource` `cellForItemAt`
  var daysCount: Int {
    switch self.displayState {
    case .daySelected(day: _, days: let days):
      return days.count
    case .notReady:
      return 0
    }
  }

  /// Return the `DayViewModel` corresponding to the passed `IndexPath`
  ///
  /// Usefull in `UICollectionViewDatasource` `numberOfElementInSection`
  ///
  /// - Parameter index: given `IndexPath`
  subscript (index: IndexPath) -> DayViewModel? {
    switch self.displayState {
    case .daySelected(day: _, days: let days):
      guard index.item < days.count && index.item >= 0 else { return nil }
      return days[index.item]

    case .notReady:
      return nil
    }
  }

  // MARK: Public methods

  // MARK: Handle user actions

  /// Handle user action, when the user select a day by scrolling or tapping on it
  ///
  /// The corresponding ViewModel will update the `CalendarDataController`
  ///
  /// - Parameter indexPath: given indexPath
  func userSelectNewDay(indexPath: IndexPath) {
    switch self.displayState {
    case .daySelected(day: _, days: let days):
      if indexPath.item < days.count && indexPath.item >= 0 {
        days[indexPath.item].userWantToShowSlotOfThisDay()
      }
    case .notReady:
      break
    }
  }

  // MARK: Private methods

  /// Everytime the displayState change, ViewModel Obeservable properties are updated
  ///
  /// - Parameter state: new `DisplayState`
  private func updateObervable(from displayState: DisplayState) {
    switch displayState {
    case .daySelected(day: let selectedDay, days: let days):
      if self.selectedIndexPath.value != IndexPath(item: selectedDay, section: 0) && selectedDay < days.count {
        self.selectedIndexPath.value = IndexPath(item: selectedDay, section: 0)
      }
    case .notReady:
      break
    }
  }

  /// Subscribe to `CalendarDataController` Observable properties
  private func setupDataController() {
    self.dataController.days.bind { [weak self] _, newModels in
      guard let `self` = self else { return }

      DispatchQueue.main.async {
        let newViewModels = newModels.map { DayViewModel(model: $0, dataController: self.dataController) }
        switch self.displayState {
        case .daySelected(day: let day, days: _):
          self.displayState = .daySelected(day: day, days: newViewModels)
          self.delegate?.shouldReloadDays()
        case .notReady:
          self.displayState = DisplayState(days: newViewModels)
          self.delegate?.shouldReloadDays()
        }
      }
    }
    
    self.dataController.selectedDay.bind { [weak self] _, day in
      guard let `self` = self else { return }
      DispatchQueue.main.async {
        switch self.displayState {
        case .daySelected(day: _, days: let days):
          self.displayState = .daySelected(day: day, days: days)
        case .notReady:
          break
        }
      }
    }

  }

  // MARK: Init

  /// Init `DaySelectorView` ViewModel
  ///
  /// - Parameter dataController: shared `CalendarDataController` accros all `CalendarViewController` viewModels
  init(dataController: CalendarDataController) {
    self.dataController = dataController
    self.displayState = DisplayState(days: dataController.days.value.map { DayViewModel(model: $0, dataController: dataController) },
                                     selectedDay: dataController.selectedDay.value)

    self.updateObervable(from: self.displayState)
    self.setupDataController()
  }

}
