# Calendar

This `UIViewController` display a Date Picker wich allow the user to select timeslot for an appoitenment for exemple.

- The componant is fully customizable from outside by depencies injection.
- Data are provided by an independent componant, and allow  lazy loading, time slot will be load on demand without interrupt the user
- Locale could be provide in order to have localized Date representation in the module ("October", "Monday " etc..)

You should provide a concrete implentation of  `CalendarDataProvider` with `loadData` and `loadNexData` implementation.

