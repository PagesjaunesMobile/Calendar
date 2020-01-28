# CalendarViewControllerOptionalDelegate

``` swift
public protocol CalendarViewControllerOptionalDelegate: class
```

## Inheritance

`class`

## Required Methods

## calendar(\_:didSelectDateAtIndexPath:)

Called when the user tap on slot

``` swift
func calendar(_ calendar: CalendarViewController, didSelectDateAtIndexPath indexPath: IndexPath)
```

## calendar(\_:calendarDidAppearOnViewController:)

Called when the `CalendarViewController` is presented

``` swift
func calendar(_ calendar: CalendarViewController, calendarDidAppearOnViewController: UIViewController?)
```

## calendar(\_:didTapOnNextDispoButton:)

Called when the user tap on the next dispo button (when there is no slot for the select day)

``` swift
func calendar(_ calendar: CalendarViewController, didTapOnNextDispoButton button: UIButton)
```

## calendar(\_:didTapOnPreviousDispoButton:)

Called when the user tap on the previous dispo button (when there is no slot for the select day)

``` swift
func calendar(_ calendar: CalendarViewController, didTapOnPreviousDispoButton button: UIButton)
```

## calendar(\_:didScrollToMonthIndexPath:)

Called when the user change current month by scrolling

``` swift
func calendar(_ calendar: CalendarViewController, didScrollToMonthIndexPath indexPath: IndexPath)
```

## calendar(\_:didSelectDay:)

Called when the user select a day by scrolling or by tapping on it

``` swift
func calendar(_ calendar: CalendarViewController, didSelectDay indexPath: IndexPath)
```

## calendar(\_:didTapOnNextMonthButton:)

Called when the user tap on the next month button

``` swift
func calendar(_ calendar: CalendarViewController, didTapOnNextMonthButton button: UIButton)
```

## calendar(\_:didTapOnPreviousMonthButton:)

Called when the user tap on the previous month button

``` swift
func calendar(_ calendar: CalendarViewController, didTapOnPreviousMonthButton button: UIButton)
```

## calendar(\_:didSelectPeriod:onSender:)

Called when the user change the display period (morning / afternoon)

``` swift
func calendar(_ calendar: CalendarViewController, didSelectPeriod period: SlotHeaderCellDelegatePeriod, onSender: UIView)
```

## calendar(\_:didTapOnNextDispoButton:)

``` swift
func calendar(_ calendar: CalendarViewController, didTapOnNextDispoButton button: UIButton)
```

## calendar(\_:didTapOnPreviousDispoButton:)

``` swift
func calendar(_ calendar: CalendarViewController, didTapOnPreviousDispoButton button: UIButton)
```

## calendar(\_:didScrollToMonthIndexPath:)

``` swift
func calendar(_ calendar: CalendarViewController, didScrollToMonthIndexPath indexPath: IndexPath)
```

## calendar(\_:didTapOnNextMonthButton:)

``` swift
func calendar(_ calendar: CalendarViewController, didTapOnNextMonthButton button: UIButton)
```

## calendar(\_:didTapOnPreviousMonthButton:)

``` swift
func calendar(_ calendar: CalendarViewController, didTapOnPreviousMonthButton button: UIButton)
```

## calendar(\_:calendarDidAppearOnViewController:)

``` swift
func calendar(_ calendar: CalendarViewController, calendarDidAppearOnViewController: UIViewController?)
```

## calendar(\_:didSelectDay:)

``` swift
func calendar(_ calendar: CalendarViewController, didSelectDay indexPath: IndexPath)
```

## calendar(\_:didSelectPeriod:onSender:)

``` swift
func calendar(_ calendar: CalendarViewController, didSelectPeriod period: SlotHeaderCellDelegatePeriod, onSender: UIView)
```

## calendar(\_:didSelectDateAtIndexPath:)

``` swift
func calendar(_ calendar: CalendarViewController, didSelectDateAtIndexPath indexPath: IndexPath)
```
