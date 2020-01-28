# CalendarViewControllerRequiredDelegate

``` swift
public protocol CalendarViewControllerRequiredDelegate: class
```

## Inheritance

`class`

## Required Methods

## calendar(\_:didTapOnCancelButton:)

Called when the user tap on the cancel button

``` swift
func calendar(_ calendar: CalendarViewController, didTapOnCancelButton button: UIButton)
```

## calendar(\_:didTapOnOkButton:andCode:)

Called when the user tap on the OK button with a selectedDate

``` swift
func calendar(_ calendar: CalendarViewController, didTapOnOkButton selectedDate: Date, andCode code: String)
```
