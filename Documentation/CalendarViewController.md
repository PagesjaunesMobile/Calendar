# CalendarViewController

Display time slot, month and day, and allow the user to select a time slot.

``` swift
public class CalendarViewController: UIViewController
```

## Inheritance

`UIViewController`, [`CalendarViewLayoutDelegate`](CalendarViewLayoutDelegate), [`DaySelectorViewDelegate`](DaySelectorViewDelegate), [`MonthSelectorViewDelegate`](MonthSelectorViewDelegate), [`NoSlotCellDelegate`](NoSlotCellDelegate), [`SlotHeaderCellDelegate`](SlotHeaderCellDelegate), [`TimeSlotListViewModelDelegate`](TimeSlotListViewModelDelegate), `UICollectionViewDataSource`, `UICollectionViewDelegate`

## Nested Types

  - CalendarViewController.Configuration
  - CalendarViewController.Configuration.CellSize

## Enumeration Cases

## normal

``` swift
case normal
```

## big

``` swift
case big
```

## Initializers

## init(configuration:)

Calendar Init

``` swift
public init(configuration: Configuration)
```

### Parameters

  - dataProvider: `CalendarDataProvider` concrete implentation provide by implemententing `loadData` and `loadNexResult` methods
  - periodFormater: `CalendarPeriodFormater` concrete implentation provide moring and afteroon name and logic to seperate them
  - shouldUseEffectView: Bool define if `UIEffectView` blur should be used in the `UICollectionView` header (`UIEffectView` blur is an heavy process and should be perfom only on powerfull device)

## init(dataProvider:theme:periodFormater:locale:shouldUseEffectView:cellSize:calendarViewControllerDelegate:)

`CalendarViewController` Configuration init

``` swift
public init(dataProvider: CalendarDataProvider, theme: CalendarViewControllerTheme = CalendarViewControllerTheme.default, periodFormater: CalendarPeriodFormater = DefaultCalendarPeriodFormater(), locale: Locale = Locale.current, shouldUseEffectView: Bool = false, cellSize: CellSize = .normal, calendarViewControllerDelegate: CalendarViewControllerDelegate? = nil)
```

  - Parameter dataProvider: Provide date information to `CalendarViewController`

<!-- end list -->

  - Parameter theme: selected `CalendarViewController` theme

<!-- end list -->

  - Parameter periodFormater: `CalendarViewController` Period formater, define if a day is Morning or Afternoon

<!-- end list -->

  - Parameter locale: Locale object to use in order to format date string (exemple October)

<!-- end list -->

  - Parameter shouldUseEffectView: Define if the `VisualEffectView`

<!-- end list -->

  - Parameter cellSize: Display mode (big or small cell size)

<!-- end list -->

  - Parameter calendarViewControllerDelegate: `CalendarViewController`

## Properties

## delegate

``` swift
var delegate: CalendarViewControllerDelegate?
```

## Methods

## viewDidAppear(\_:)

``` swift
override public func viewDidAppear(_ animated: Bool)
```

## viewDidLoad()

``` swift
override public func viewDidLoad()
```

## numberOfSections(in:)

``` swift
public func numberOfSections(in collectionView: UICollectionView) -> Int
```

## collectionView(\_:numberOfItemsInSection:)

``` swift
public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
```

## collectionView(\_:cellForItemAt:)

``` swift
public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
```

## collectionView(\_:viewForSupplementaryElementOfKind:at:)

``` swift
public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
```

## collectionView(\_:didSelectItemAt:)

``` swift
public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
```
