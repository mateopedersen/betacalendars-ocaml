# Beta Calendars for OCaml

Presentation-neutral Gregorian calendar structures for applications and temporal regression tests. This synchronous library models civil dates directly; it does not use timestamps or local time zones.

## Why another calendar library?

`calendar` provides broad date/time functionality and `calendars` focuses on conversion among calendar systems. Beta Calendars focuses on deterministic month/year grids, bounded recurrence expansion, date ranges, boundary data, and fixtures for applications and tests.

## Installation

```sh
opam install betacalendars
```

## Quick start

```ocaml
open Betacalendars
let date = Civil_date.make ~year:2027 ~month:1 ~day:1
let grid = Month_grid.make ~year:2027 ~month:1
  ~first_weekday:Weekday.Monday ~layout:Month_grid.Fixed_six_weeks
  ~overflow:Month_grid.Adjacent_dates ()
```

`Civil_date.make` validates years 1–9999 and returns a structured result. `add_days` is timezone independent. Month grids expose rows of seven cells; fixed mode always returns 42 cells. Overflow cells either carry adjacent valid dates or `None`.

`Year_grid.make` returns January through December. `Date_range` is inclusive and provides iteration/fold before materializing lists. `Recurrence.expand` always requires a finite `Date_range`; it supports day intervals, weekdays, monthly/annual dates with explicit invalid-day policies, and ordinal/last weekdays. It is intentionally not a full RFC 5545 implementation.

`Boundary.for_year` and `Fixture.year_turn_window` produce deterministic structured values for regression tests. No API reads the clock, environment, network, or filesystem.

## Compatibility and docs

The package targets OCaml 4.14 and later. API documentation is generated with odoc. See [CONTRIBUTING.md](CONTRIBUTING.md), [SECURITY.md](SECURITY.md), and [CHANGES.md](CHANGES.md).

## Project

Beta Calendars for OCaml is maintained as part of the [Beta Calendars developer tooling project](https://www.betacalendars.com/).

## License

MIT. See [LICENSE](LICENSE).
