/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation

/// MARK: - SlotDataControllerModel

/// Represent a Slot in the `CalendarDataController`
struct SlotDataControllerModel {

  /// Stored code will passed trought the `CalendarViewControllerDelegate` if the user select this slot.
  let code: String

  /// Date of this slot, will be passed trought the `CalendarViewControllerDelegate` if the user select this slot.
  let originalDate: Date

  /// Init of SlotDataControllerModel from a `SlotDataProviderModel`
  ///
  /// - Parameter model: slot returned by a `CalendarDataProvider` concrete instance
  init(model: SlotDataProviderModel) {
    self.code = model.code
    self.originalDate = model.originalDate
  }
}

/// MARK: - Equatable

extension SlotDataControllerModel: Equatable {
  static func == (lhrs: SlotDataControllerModel, rhs: SlotDataControllerModel) -> Bool {
    return lhrs.code == rhs.code
  }
}
