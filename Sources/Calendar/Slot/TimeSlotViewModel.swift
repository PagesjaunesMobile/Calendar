/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation

// MARK: - TimeSlotViewModel

/// ViewModel designed to work with `CalendarSlotCell`,
/// represent a calendar slot
class TimeSlotViewModel {

  // MARK: Private properties

  /// `CalendarDataController` slot model
  private let originalModel: SlotDataControllerModel

  /// Shared `CalendarDataController` accros all `CalendarViewController` viewModels
  private let dataController: CalendarDataController

  // MARK: Public properties

  /// Text to display in the `CalendarSlotCell`
  let displayText: String

  // MARK: Public computed properties

  /// Indicate if the current slot is in the moring or afternoon period
  /// the evaluation is done in the `CalendarDataController`
  var isAfternoon: Bool {
    return self.originalModel.isAfternoon
  }

  // MARK: Read only public properties

  /// Observable property indicate if the current slot is selected
  private (set) var isSelected = CalendarObservable<Bool>(false)

  // MARK: Public methods

  /// This slot is designed as the selected slot,
  /// should be called when the user tap on the cell
  func select() {
    if self.dataController.updateSelectedSlot(slot: self.originalModel) == true {
      self.isSelected.value = true
    }
  }

  /// This slot is not designed as selected slot, should be called everytime
  /// the selection change to be sure the selected of the other `CalendarSlotCell` is correct
  func unSelect() {
    self.isSelected.value = false
  }

  // MARK: Init

  /// `CalendarSlotCell` viewModel init
  ///
  /// - Parameters:
  ///   - model: `CalendarDataController` slot model
  ///   - dataController: Shared `CalendarDataController` accros all `CalendarViewController` viewModels
  init(model: SlotDataControllerModel, dataController: CalendarDataController) {
    self.originalModel = model
    self.displayText = model.displayText
    self.dataController = dataController
  }
}

// MARK: - Equatable

extension TimeSlotViewModel: Equatable {
  static func == (lhr: TimeSlotViewModel, rhs: TimeSlotViewModel) -> Bool {
    return lhr.originalModel == rhs.originalModel
  }
}
