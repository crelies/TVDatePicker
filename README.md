# 📅 TVDatePicker

A `SwiftUI` `DatePicker` view for `tvOS`

[![Swift 5.3](https://img.shields.io/badge/swift-5.3-green.svg?longCache=true&style=flat-square)](https://developer.apple.com/swift)
[![Platforms](https://img.shields.io/badge/platform-tvOS-lightgrey.svg?longCache=true&style=flat-square)](https://www.apple.com)
[![Current Version](https://img.shields.io/github/v/tag/crelies/TVDatePicker?longCache=true&style=flat-square)](https://github.com/crelies/TVDatePicker)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg?longCache=true&style=flat-square)](https://en.wikipedia.org/wiki/MIT_License)

## ❤️ Motivation

Currently there is no native `SwiftUI` `DatePicker` for `tvOS`. That's why I created this Swift package to fill the hole 😊
The `API` mimics the one of the native `SwiftUI` `DatePicker` available for `iOS`, `macOS` and `macCatalyst`. 

## ℹ️ Installation

**First release published soon ...**

Just add this Swift package as a dependency to your `Package.swift`:

```swift
.package(url: "https://github.com/crelies/TVDatePicker.git", from: "0.1.0")
```

## 🧭 Usage

The following code snippet shows how to use the `DatePicker` `view` in your `tvOS` application:

```swift
TVDatePicker(
    _ titleKey: LocalizedStringKey,
    selection: Binding<Date>,
    minimumDate: Date,
    displayedComponents: Components = .all,
    calendar: Calendar = .current,
    dateFormatter: DateFormatter = DateFormatters.defaultFormatter,
    label: () -> Label
) // Available when Label conforms to View.
```

## 📖 Implementation

The `DatePicker` view is implemented by using multiple `Picker`s with the `SegmentedPickerStyle` inside a `List` / `VStack`.
Each `Picker` represents a date component like `year`, `month` or `date`. Due to issues with the focus engine the implementation slightly differs for the supported tvOS versions `13.0`, `14.0` and > `14.0`. But I think that you can ignore this detail in most cases.

## 🔒 Limitations

- ⚠️ The `DatePicker` was only tested with the `Gregorian calendar`.
- The `year` component displays only `10` years at a time (selected year +/- 5 years with respect to the year of the specified minimum date).
- Currently the `hourAndMinute` component only supports the `24-hour` mode and not the `am/pm` mode.
- The `hourAndMinute` component supports only steps by five for the `minute`. 
