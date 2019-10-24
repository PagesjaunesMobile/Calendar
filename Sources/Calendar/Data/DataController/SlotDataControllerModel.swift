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

  let displayText: String

  /// Init of SlotDataControllerModel from a `SlotDataProviderModel`
  ///
  /// - Parameter model: slot returned by a `CalendarDataProvider` concrete instance
  public init(model: SlotDataProviderModel, formater: CalendarDataController.CalendarDateFormater) {
    self.code = model.code
    self.originalDate = model.originalDate
    self.displayText = formater.extractHoursAndMinutes(date: model.originalDate)
  }
}

/// MARK: - Equatable

extension SlotDataControllerModel: Equatable {
  public static func == (lhrs: SlotDataControllerModel, rhs: SlotDataControllerModel) -> Bool {
    return lhrs.code == rhs.code
  }
}
