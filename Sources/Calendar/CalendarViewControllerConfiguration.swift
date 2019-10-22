/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation

extension CalendarViewController {

  public struct Configuration {

    public enum CellSize {
      case normal
      case big

      var isBigCell: Bool {
        switch self {
        case .normal:
          return false
        case .big:
          return true
        }
      }
    }

    
    let theme: CalendarViewControllerTheme
    let dataProvider: CalendarDataProvider
    let periodFormater: CalendarPeriodFormater
    let locale: Locale
    let shouldUseEffectView: Bool
    let cellSize: CellSize
    let calendarViewControllerDelegate: CalendarViewControllerDelegate?
    
    public init(dataProvider: CalendarDataProvider,
                theme: CalendarViewControllerTheme = CalendarViewControllerTheme.default,
                periodFormater: CalendarPeriodFormater = DefaultCalendarPeriodFormater(),
                locale: Locale = Locale.current,
                shouldUseEffectView: Bool = false,
                cellSize: CellSize = .normal,
                calendarViewControllerDelegate: CalendarViewControllerDelegate? = nil) {
      self.dataProvider = dataProvider
      self.periodFormater = periodFormater
      self.locale = locale
      self.shouldUseEffectView = shouldUseEffectView
      self.calendarViewControllerDelegate = calendarViewControllerDelegate
      self.theme = theme
      self.cellSize = cellSize
    }


  }
  
}
