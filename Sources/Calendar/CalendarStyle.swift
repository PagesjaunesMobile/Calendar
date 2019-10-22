/*
* Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
*
* Unauthorized copying of this file, via any medium is strictly prohibited.
* Proprietary and confidential.
*/

import Foundation
import UIKit

protocol DaySelectorCellStyle {
  var dayNumberLabelFont: UIFont { get }
  var dayNumberLabelColor: UIColor { get }

  var dayTextLabelFont: UIFont { get }
  var dayTextLabelColor: UIColor { get }
}

protocol DaySelectorViewStyle {
  var glassViewBackgroundColor: UIColor { get }
}

protocol CalendarOkCancelStyle {
  var enabledColor: UIColor { get }
  var disabledColor: UIColor { get }
  var buttonFont: UIFont { get }
}

protocol CalendarSlotCellStyle {

  var slotSelectedBackgroundColor: UIColor { get }
  var slotSelectedTitleColor: UIColor { get }

  var slotDeselectedBackgroundColor: UIColor { get }
  var slotDeselectedTitleColor: UIColor { get }

  var slotTitleFont: UIFont { get }
  var slotBorderColor: UIColor { get }
}

protocol NoSlotCellStyle {
  var noSlotCellTitleTextColor: UIColor { get }
  var noSlotCellTitleFont: UIFont { get }
  var noSlotCellSperatorColor: UIColor { get }
  var noSlotCellAlviableDayTextColor: UIColor { get }
  var noSlotCellAlviableDayTextFont: UIFont { get }
}

protocol AlviableViewStyle {

  var alviableLeftButtonImage: UIImage { get }
  var alviableRightButtonImage: UIImage { get }
  var alviableNormalBackgroundColor: UIColor { get }
  var alviableHighlightBackgroundColor: UIColor { get }

  var alviableDayOfWeekFont: UIFont { get }
  var alviableDayOfWeekColor: UIColor { get }

  var alviableDayNumberOfMonthFont: UIFont { get }
  var alviableDayNumberOfMonthColor: UIColor { get }

  var alviableSlotHourLabelFont: UIFont { get }
  var alviableSlotHourLabelTextColor: UIColor { get }
  var alviableSlotBorderColor: UIColor { get }
}

protocol MonthSelectorViewStyle {
  var monthSelectorViewLeftButtonEnabledImage: UIImage { get }
  var monthSelectorViewRightButtoEnablednImage: UIImage { get }

  var monthSelectorViewLeftButtonDisabledImage: UIImage { get }
  var monthSelectorViewRightButtonDisabledImage: UIImage { get }
}

protocol MonthCellStyle {
  var monthCellMonthTitleTextColor: UIColor { get }
  var monthCellMonthTitleTextFont: UIFont { get }

  var monthCellYearTitleTextColor: UIColor { get }
  var monthCellYearTitleTextFont: UIFont { get }
}

protocol HeaderViewStyle {
  var headerViewSepararorColor: UIColor { get }
}


protocol CalendarStyle {
  var daySelectorCell: DaySelectorCellStyle { get }
  var daySelectorView: DaySelectorViewStyle { get }
  var okCancelButtons: CalendarOkCancelStyle { get }
  var slotCell: CalendarSlotCellStyle { get }
  var noSlotCell: NoSlotCellStyle { get }
  var alviableView: AlviableViewStyle { get }
  var monthSelectorView: MonthSelectorViewStyle { get }
  var monthCell: MonthCellStyle { get }
  var header: HeaderViewStyle { get }
}
