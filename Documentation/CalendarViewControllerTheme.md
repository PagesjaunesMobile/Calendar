# CalendarViewControllerTheme

Theme for `CalendarViewController`, describe UI Properties (Color / Font) for all graphical component

``` swift
public struct CalendarViewControllerTheme
```

## Nested Types

  - CalendarViewControllerTheme.DaySelectorCellTheme
  - CalendarViewControllerTheme.DaySelectorViewTheme
  - CalendarViewControllerTheme.OkCancelTheme
  - CalendarViewControllerTheme.SlotCellTheme
  - CalendarViewControllerTheme.NoSlotCellTheme
  - CalendarViewControllerTheme.AlviableViewTheme
  - CalendarViewControllerTheme.MonthSelectorViewTheme
  - CalendarViewControllerTheme.MonthCellTheme
  - CalendarViewControllerTheme.HeaderViewTheme

## Properties

## daySelectorCell

Describe the theme for the `DaySelectorCell`, the view wich display one day data

``` swift
var daySelectorCell: DaySelectorCellTheme
```

## daySelectorView

Describe the theme for the `DaySelectorView`, the view wich display Days

``` swift
var daySelectorView: DaySelectorViewTheme
```

## okCancelButtons

Theme for the ok and the cancel button on top of the `UIViewController`

``` swift
var okCancelButtons: OkCancelTheme
```

## slotCell

Theme for `SlotCell`, the slot cell wich are display in the main `UICollectionView` on the `CalendarViewController`

``` swift
var slotCell: SlotCellTheme
```

## noSlotCell

Theme for the `NoSlotCell`, this cell is is display when there is no slot for the selected day

``` swift
var noSlotCell: NoSlotCellTheme
```

## alviableView

Theme for the `AlviableView`, this view is display inside the `NoSlotCell`
view to inform the user about the next or the previous alviable slot

``` swift
var alviableView: AlviableViewTheme
```

## monthSelectorView

Theme for the `MonthSelectorView`, this view is responsible
of display and select th current month

``` swift
var monthSelectorView: MonthSelectorViewTheme
```

## monthCell

Theme for the Month cell, represent one month in the `MonthSelectorView`

``` swift
var monthCell: MonthCellTheme
```

## header

Theme for the `HeaderView` container for the `MonthSelectorView` and the `DaySelectorView`

``` swift
var header: HeaderViewTheme
```

## \`default\`

Default theme

``` swift
let `default`: Self = {

    let dest = CalendarViewControllerTheme(daySelectorCell: DaySelectorCellTheme.default,
                                           daySelectorView: DaySelectorViewTheme.default,
                                           okCancelButtons: OkCancelTheme.default,
                                           slotCell: SlotCellTheme.default,
                                           noSlotCell: NoSlotCellTheme.default,
                                           alviableView: AlviableViewTheme.default,
                                           monthSelectorView: MonthSelectorViewTheme.default,
                                           monthCell: MonthCellTheme.default,
                                           header: HeaderViewTheme.default)
    return dest
  }()
```

## dayNumberLabelFont

Font for the `DayNumberLabel` represent the day of the month

``` swift
var dayNumberLabelFont: UIFont
```

## dayNumberLabelColor

Color for the `DayNumberLabel` represent the day of the month

``` swift
var dayNumberLabelColor: UIColor
```

## dayTextLabelFont

Font for the `dayTextLabel` represent the day of the week text (exemple Jeu.)

``` swift
var dayTextLabelFont: UIFont
```

## dayTextLabelColor

Color for the `dayTextLabel` represent the day of the week text (exemple Jeu.)

``` swift
var dayTextLabelColor: UIColor
```

## \`default\`

Default theme

``` swift
let `default`: Self = {
      var dest = DaySelectorCellTheme(dayNumberLabelFont: UIFont.systemFont(ofSize: 32),
                                      dayNumberLabelColor: UIColor.black,
                                      dayTextLabelFont: UIFont.systemFont(ofSize: 17),
                                      dayTextLabelColor: UIColor.black)

      dest.dayNumberLabelFont = UIFont.systemFont(ofSize: 32)
      dest.dayNumberLabelColor = UIColor.black
      dest.dayTextLabelFont = UIFont.systemFont(ofSize: 17)
      dest.dayTextLabelColor = UIColor.black
      return dest
    }()
```

## glassViewBackgroundColor

Color of the glassView, the view on the center of the `DaySelectorView` wich indicate the selection.

``` swift
var glassViewBackgroundColor: UIColor
```

## \`default\`

Default theme

``` swift
let `default`: Self = {
      let dest = DaySelectorViewTheme(glassViewBackgroundColor: UIColor.lightGray)
      return dest
    }()
```

## enabledColor

Color when the button is enable

``` swift
var enabledColor: UIColor
```

## disabledColor

Color when the button is disabled

``` swift
var disabledColor: UIColor
```

## buttonFont

Ok / Cancel button font

``` swift
var buttonFont: UIFont
```

## \`default\`

Default theme

``` swift
let `default`: Self = {
      let dest = OkCancelTheme(enabledColor: UIColor.blue,
                               disabledColor: UIColor.lightGray,
                               buttonFont: UIFont.boldSystemFont(ofSize: 17))
      return dest
    }()
```

## selectedBackgroundColor

Color of the slot cell background when the slot is selected

``` swift
var selectedBackgroundColor: UIColor
```

## selectedTitleColor

Color of the slot cell title color when the slot is selected

``` swift
var selectedTitleColor: UIColor
```

## deselectedBackgroundColor

Color of the slot cell background when the slot is deselected

``` swift
var deselectedBackgroundColor: UIColor
```

## deselectedTitleColor

Color of the slot cell title color when the slot is selected

``` swift
var deselectedTitleColor: UIColor
```

## titleFont

Slot title font

``` swift
var titleFont: UIFont
```

## borderColor

`SlotCell` border color

``` swift
var borderColor: UIColor
```

## \`default\`

Default theme

``` swift
let `default`: Self = {

      let dest = SlotCellTheme(selectedBackgroundColor: UIColor.blue,
                               selectedTitleColor: UIColor.white,
                               deselectedBackgroundColor: UIColor.white,
                               deselectedTitleColor: UIColor.blue,
                               titleFont: UIFont.systemFont(ofSize: 16),
                               borderColor: UIColor.blue)
      return dest
      
    }()
```

## titleTextColor

Title color of the `NoSlotCell` the title on the top of the view

``` swift
var titleTextColor: UIColor
```

## titleFont

Font of the `NoSlotCell` the title on the top of the view

``` swift
var titleFont: UIFont
```

## speratorColor

Separator view color between the title and the alviable view label

``` swift
var speratorColor: UIColor
```

## alviableDayTextColor

Alviable view title text color, this title explain to the user, the remaining slot options

``` swift
var alviableDayTextColor: UIColor
```

## alviableDayTextFont

Alviable view font, this title explain to the user, the remaining slot options

``` swift
var alviableDayTextFont: UIFont
```

## \`default\`

Default theme

``` swift
let `default`: Self = {
      let dest = NoSlotCellTheme(titleTextColor: UIColor.gray,
                                 titleFont: UIFont.systemFont(ofSize: 24),
                                 speratorColor: UIColor.gray,
                                 alviableDayTextColor: UIColor.gray,
                                 alviableDayTextFont: UIFont.systemFont(ofSize: 17))
      return dest
    }()
```

## leftButtonImage

Button image for the previous alviable slot button

``` swift
var leftButtonImage: UIImage?
```

## rightButtonImage

Button image for the next alviable slot button

``` swift
var rightButtonImage: UIImage?
```

## normalBackgroundColor

Normal state background color for the `AlviableView`

``` swift
var normalBackgroundColor: UIColor
```

## highlightBackgroundColor

Highlight state background color for the `AlviableView`

``` swift
var highlightBackgroundColor: UIColor
```

## dayOfWeekFont

Font for the `dayOfWeek` label in the `AlviableView` (jeu.)

``` swift
var dayOfWeekFont: UIFont
```

## dayOfWeekColor

Color for the `dayOfWeek` label in the `AlviableView` (jeu.)

``` swift
var dayOfWeekColor: UIColor
```

## dayNumberOfMonthFont

Font for the `dayNumberOfMonth` label in the `AlviableView` (24)

``` swift
var dayNumberOfMonthFont: UIFont
```

## dayNumberOfMonthColor

Color for the `dayNumberOfMonth` label in the `AlviableView` (24)

``` swift
var dayNumberOfMonthColor: UIColor
```

## alviableSlotHourLabelFont

Font for the `alviableSlotHourLabel` label in the `AlviableView` (13h00)

``` swift
var alviableSlotHourLabelFont: UIFont
```

## alviableSlotHourLabelTextColor

Color for the `alviableSlotHourLabel` label in the `AlviableView` (13h00)

``` swift
var alviableSlotHourLabelTextColor: UIColor
```

## borderColor

`AlviableView` border color

``` swift
var borderColor: UIColor
```

## \`default\`

Default theme

``` swift
let `default`: Self = {
      let dest = AlviableViewTheme(leftButtonImage: nil,
                                   rightButtonImage: nil,
                                   normalBackgroundColor: UIColor.blue,
                                   highlightBackgroundColor: UIColor.white,
                                   dayOfWeekFont: UIFont.systemFont(ofSize: 17),
                                   dayOfWeekColor: UIColor.blue,
                                   dayNumberOfMonthFont: UIFont.systemFont(ofSize: 32),
                                   dayNumberOfMonthColor: UIColor.blue,
                                   alviableSlotHourLabelFont: UIFont.systemFont(ofSize: 17),
                                   alviableSlotHourLabelTextColor: UIColor.blue,
                                   borderColor: UIColor.blue)
      return dest
    }()
```

## leftButtonEnabledImage

Button for the previous button of the `MonthSelectorView` in the enabled mode

``` swift
var leftButtonEnabledImage: UIImage?
```

## rightButtoEnablednImage

Button for the next button of the `MonthSelectorView` in the enabled mode

``` swift
var rightButtoEnablednImage: UIImage?
```

## leftButtonDisabledImage

Button for the previous button of the `MonthSelectorView` in the disabled mode

``` swift
var leftButtonDisabledImage: UIImage?
```

## rightButtonDisabledImage

Button for the next button of the `MonthSelectorView` in the enabled mode

``` swift
var rightButtonDisabledImage: UIImage?
```

## \`default\`

Default theme

``` swift
let `default`: Self = {
      let dest = MonthSelectorViewTheme(leftButtonEnabledImage: nil,
                                        rightButtoEnablednImage: nil,
                                        leftButtonDisabledImage: nil,
                                        rightButtonDisabledImage: nil)
      return dest
    }()
```

## monthTitleTextColor

Describe the text color of the month title of the `MonthCell` (Janvier)

``` swift
var monthTitleTextColor: UIColor
```

## monthTitleTextFont

Describe the text font of the month title of the `MonthCell` (Janvier)

``` swift
var monthTitleTextFont: UIFont
```

## yearTitleTextColor

Describe the text color of the year title of the `MonthCell` (2019)

``` swift
var yearTitleTextColor: UIColor
```

## yearTitleTextFont

Describe the text font of the year title of the `MonthCell` (2019)

``` swift
var yearTitleTextFont: UIFont
```

## \`default\`

Default theme

``` swift
let `default`: Self = {
      let dest = MonthCellTheme(monthTitleTextColor: UIColor.black,
                                monthTitleTextFont: UIFont.systemFont(ofSize: 32),
                                yearTitleTextColor: UIColor.black,
                                yearTitleTextFont: UIFont.systemFont(ofSize: 17))
      return dest
    }()
```

## separarorColor

Describe the color between the `DayViewSelector`, the `MonthSelectorView` and the slots

``` swift
var separarorColor: UIColor
```

## \`default\`

Default theme

``` swift
let `default`: Self = {
      let dest = HeaderViewTheme(separarorColor: UIColor.gray)
      return dest
    }()
```
