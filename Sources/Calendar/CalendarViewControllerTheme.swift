/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation
import UIKit

public struct CalendarViewControllerTheme {
  public var daySelectorCell: DaySelectorCellStyle
  public var daySelectorView: DaySelectorViewStyle
  public var okCancelButtons: OkCancelStyle
  public var slotCell: SlotCellStyle
  public var noSlotCell: NoSlotCellStyle
  public var alviableView: AlviableViewStyle
  public var monthSelectorView: MonthSelectorViewStyle
  public var monthCell: MonthCellStyle
  public var header: HeaderViewStyle

  public static let `default`: Self = {

    let dest = CalendarViewControllerTheme(daySelectorCell: DaySelectorCellStyle.default,
                                           daySelectorView: DaySelectorViewStyle.default,
                                           okCancelButtons: OkCancelStyle.default,
                                           slotCell: SlotCellStyle.default,
                                           noSlotCell: NoSlotCellStyle.default,
                                           alviableView: AlviableViewStyle.default,
                                           monthSelectorView: MonthSelectorViewStyle.default,
                                           monthCell: MonthCellStyle.default,
                                           header: HeaderViewStyle.default)
    return dest
  }()
}

extension CalendarViewControllerTheme {

  public struct DaySelectorCellStyle {
    public var dayNumberLabelFont: UIFont //UIFont.diloRoman(size: 32)
    public var dayNumberLabelColor: UIColor // UIColor.black
    public var dayTextLabelFont: UIFont  // UIFont.diloRoman(size: 17)
    public var dayTextLabelColor: UIColor // UIColor.black

    public static let `default`: Self = {
      var dest = DaySelectorCellStyle(dayNumberLabelFont: UIFont.systemFont(ofSize: 32),
                                      dayNumberLabelColor: UIColor.black,
                                      dayTextLabelFont: UIFont.systemFont(ofSize: 17),
                                      dayTextLabelColor: UIColor.black)

      dest.dayNumberLabelFont = UIFont.systemFont(ofSize: 32)
      dest.dayNumberLabelColor = UIColor.black
      dest.dayTextLabelFont = UIFont.systemFont(ofSize: 17)
      dest.dayTextLabelColor = UIColor.black
      return dest
    }()

  }

  public struct DaySelectorViewStyle {
    public var glassViewBackgroundColor: UIColor // UIColor.grey2()

    public static let `default`: Self = {
      let dest = DaySelectorViewStyle(glassViewBackgroundColor: UIColor.lightGray)
      return dest
    }()

  }

  public struct OkCancelStyle {
    public var enabledColor: UIColor // UIColor.bluePJ()
    public var disabledColor: UIColor // UIColor.lightGray
    public var buttonFont: UIFont // UIFont.boldSystemFont(ofSize: 17)

    public static let `default`: Self = {
      let dest = OkCancelStyle(enabledColor: UIColor.blue,
                               disabledColor: UIColor.lightGray,
                               buttonFont: UIFont.boldSystemFont(ofSize: 17))
      return dest
    }()

  }

  public struct SlotCellStyle {
    public var slotSelectedBackgroundColor: UIColor // UIColor.bluePJ()
    public var slotSelectedTitleColor: UIColor //UIColor.white

    public var slotDeselectedBackgroundColor: UIColor // UIColor.white
    public var slotDeselectedTitleColor: UIColor  //UIColor.bluePJ()

    public var slotTitleFont: UIFont  //UIFont.diloRoman(size: 16)
    public var slotBorderColor: UIColor //UIColor.bluePJ()

    public static let `default`: Self = {

      let dest = SlotCellStyle(slotSelectedBackgroundColor: UIColor.blue,
                               slotSelectedTitleColor: UIColor.white,
                               slotDeselectedBackgroundColor: UIColor.white,
                               slotDeselectedTitleColor: UIColor.blue,
                               slotTitleFont: UIFont.systemFont(ofSize: 16),
                               slotBorderColor: UIColor.blue)
      return dest
      
    }()


  }

  public struct NoSlotCellStyle {
    public var noSlotCellTitleTextColor: UIColor //UIColor.grey5()
    public var noSlotCellTitleFont: UIFont //UIFont.diloLight(size: 24)
    public var noSlotCellSperatorColor: UIColor //UIColor.grey3()
    public var noSlotCellAlviableDayTextColor: UIColor //UIColor.grey6()
    public var noSlotCellAlviableDayTextFont: UIFont  //UIFont.diloBold(size: 17)

    public static let `default`: Self = {
      let dest = NoSlotCellStyle(noSlotCellTitleTextColor: UIColor.gray,
                                 noSlotCellTitleFont: UIFont.systemFont(ofSize: 24),
                                 noSlotCellSperatorColor: UIColor.gray,
                                 noSlotCellAlviableDayTextColor: UIColor.gray,
                                 noSlotCellAlviableDayTextFont: UIFont.systemFont(ofSize: 17))
      return dest
    }()
  }

  public struct AlviableViewStyle {
    public var alviableLeftButtonImage: UIImage  //UIImage.resize(#imageLiteral(resourceName: "chevronGauche"), size: KitUIAssetSize._16pt, color: UIColor.bluePJ())
    public var alviableRightButtonImage: UIImage  // UIImage.resize(#imageLiteral(resourceName: "chevronDroit"), size: KitUIAssetSize._16pt, color: UIColor.bluePJ())
    public var alviableNormalBackgroundColor: UIColor //UIColor.bluePJ().withAlphaComponent(0.2)
    public var alviableHighlightBackgroundColor: UIColor // UIColor.white

    public var alviableDayOfWeekFont: UIFont  //UIFont.diloRoman(size: 17)
    public var alviableDayOfWeekColor: UIColor // UIColor.bluePJ()

    public var alviableDayNumberOfMonthFont: UIFont  //UIFont.diloRoman(size: 32)
    public var alviableDayNumberOfMonthColor: UIColor  //UIColor.bluePJ()

    public var alviableSlotHourLabelFont: UIFont //UIFont.diloRoman(size: 17)
    public var alviableSlotHourLabelTextColor: UIColor  //UIColor.bluePJ()
    public var alviableSlotBorderColor: UIColor  //UIColor.bluePJ()

    public static let `default`: Self = {
      let dest = AlviableViewStyle(alviableLeftButtonImage: UIImage(),
                                   alviableRightButtonImage: UIImage(),
                                   alviableNormalBackgroundColor: UIColor.blue,
                                   alviableHighlightBackgroundColor: UIColor.white,
                                   alviableDayOfWeekFont: UIFont.systemFont(ofSize: 17),
                                   alviableDayOfWeekColor: UIColor.blue,
                                   alviableDayNumberOfMonthFont: UIFont.systemFont(ofSize: 32),
                                   alviableDayNumberOfMonthColor: UIColor.blue,
                                   alviableSlotHourLabelFont: UIFont.systemFont(ofSize: 17),
                                   alviableSlotHourLabelTextColor: UIColor.blue,
                                   alviableSlotBorderColor: UIColor.blue)
      return dest
    }()

  }

  public struct MonthSelectorViewStyle {
    public var monthSelectorViewLeftButtonEnabledImage: UIImage  // UIImage.resize(#imageLiteral(resourceName: "chevronGauche"), size: KitUIAssetSize._16pt, color: .black)
    public var monthSelectorViewRightButtoEnablednImage: UIImage // UIImage.resize(#imageLiteral(resourceName: "chevronDroit"), size: KitUIAssetSize._16pt, color: .black)

    public var monthSelectorViewLeftButtonDisabledImage: UIImage  //UIImage.resize(#imageLiteral(resourceName: "chevronGauche"), size: KitUIAssetSize._16pt, color: .grey3())
    public var monthSelectorViewRightButtonDisabledImage: UIImage  //UIImage.resize(#imageLiteral(resourceName: "chevronDroit"), size: KitUIAssetSize._16pt, color: UIColor.grey3())

    public static let `default`: Self = {
      let dest = MonthSelectorViewStyle(monthSelectorViewLeftButtonEnabledImage: UIImage(),
                                        monthSelectorViewRightButtoEnablednImage: UIImage(),
                                        monthSelectorViewLeftButtonDisabledImage: UIImage(),
                                        monthSelectorViewRightButtonDisabledImage: UIImage())
      return dest
    }()

  }

  public struct MonthCellStyle {
    public var monthCellMonthTitleTextColor: UIColor  //UIColor.black
    public var monthCellMonthTitleTextFont: UIFont // UIFont.systemFont(ofSize: 32) // UIFont.diloRoman(size: 32)

    public var monthCellYearTitleTextColor: UIColor // UIColor.black
    public var monthCellYearTitleTextFont: UIFont // UIFont.systemFont(ofSize: 32) // UIFont.diloRoman(size:

    public static let `default`: Self = {
      let dest = MonthCellStyle(monthCellMonthTitleTextColor: UIColor.black,
                                monthCellMonthTitleTextFont: UIFont.systemFont(ofSize: 32),
                                monthCellYearTitleTextColor: UIColor.black,
                                monthCellYearTitleTextFont: UIFont.systemFont(ofSize: 32))
      return dest
    }()

  }

  public struct HeaderViewStyle {
    public var headerViewSepararorColor: UIColor  // UIColor.grey3()

    public static let `default`: Self = {
      let dest = HeaderViewStyle(headerViewSepararorColor: UIColor.gray)
      return dest
    }()

  }
}
