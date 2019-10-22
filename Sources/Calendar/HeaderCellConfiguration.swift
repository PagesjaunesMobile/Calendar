/*
* Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
*
* Unauthorized copying of this file, via any medium is strictly prohibited.
* Proprietary and confidential.
*/

import Foundation

struct HeaderCellConfiguration {
  let monthListViewModel: MonthListViewModel
  let dayListViewModel: DayListViewModel
  let delegate: HeaderCellDelegate
  let shouldUseEffectView: Bool
  let theme: CalendarViewControllerTheme
}
