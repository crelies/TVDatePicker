//
//  TVDatePicker.swift
//  TVDatePicker
//
//  Created by Christian Elies on 20.12.20.
//  Copyright © 2020 Christian Elies. All rights reserved.
//

import SwiftUI

/// A `SwiftUI` date picker view, especially for tvOS.
public struct TVDatePicker<Label: View>: View {
    // MARK: - Private

    private let pickerStyle = SegmentedPickerStyle()

    private var currentYear: Int {
        calendar.component(.year, from: minimumDate)
    }

    private var months: Range<Int> {
        calendar.range(of: .month, in: .year, for: minimumDate) ?? Range(0...0)
    }

    private var days: Range<Int> {
        calendar.range(of: .day, in: .month, for: minimumDate) ?? Range(0...0)
    }

    private var hours: Range<Int> { Range(0...23) }

    private var minutes: Array<Int> { Array(stride(from: 0, to: 60, by: 5)) }

    @State private var isSheetPresented = false
    @State private var selectedYear: Int = 0
    @State private var selectedMonth: Int = 0
    @State private var selectedDay: Int = 0
    @State private var selectedHour: Int = 0
    @State private var selectedMinute: Int = 0

    // MARK: - Internal

    var titleKey: LocalizedStringKey
    @Binding var selection: Date
    var minimumDate: Date
    var displayedComponents: Components
    var calendar: Calendar = .current
    var dateFormatter: DateFormatter
    var label: () -> Label

    // MARK: - Public

    /// Represents the available components of the date picker view.
    public struct Components: OptionSet {
        /// Displays hour and minute components based on the locale.
        public static var hourAndMinute: Components { Components(rawValue: 1) }
        /// Displays the year based on the locale.
        public static var year: Components { Components(rawValue: 1 << 1) }
        /// Displays the month based on the locale.
        public static var month: Components { Components(rawValue: 1 << 2) }
        /// Displays the day based on the locale.
        public static var date: Components { Components(rawValue: 1 << 3) }
        /// Displays day, month, and year based on the locale.
        public static var all: Components { [.year, .month, .date] }

        public var rawValue: Int8

        public init(rawValue: Int8) {
            self.rawValue = rawValue
        }
    }

    public var body: some View {
        Button {
            isSheetPresented = true
        } label: {
            HStack {
                label()
                Spacer()
                Text(dateFormatter.string(from: selection))
                Image(systemName: "chevron.right")
            }
        }
        .background(
            EmptyView()
                .sheet(isPresented: $isSheetPresented, onDismiss: {
                    isSheetPresented = false
                }) {
                    if #available(tvOS 14.2, *) {
                        NavigationView(content: navigationViewContent)
                    // We have to avoid a navigation view on tvOS 14 because the focus engine is broken after focusing the dismiss button in the toolbar.
                    } else if #available(tvOS 14, *) {
                        VStack {
                            HStack {
                                Text(titleKey).foregroundColor(.secondary).font(.title2)
                                dismissButton()
                            }

                            Spacer()

                            navigationViewContent()

                            Spacer()
                        }
                    } else {
                        NavigationView(content: navigationViewContent)
                    }
                }
        )
    }

    /// Initializes the date picker view with the given values.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of self, describing its purpose.
    ///   - selection: The date value being displayed and selected.
    ///   - minimumDate: The minimum date of the date picker view.
    ///   - displayedComponents: The date components that user is able to view and edit, defaults to `.all` alias `[.year, .month, .date]`.
    ///   - calendar: The calendar used by the date picker view, defaults to `.current`.
    ///   - dateFormatter: The date formatter used for displaying the current selection, defaults to `DateFormatters.defaultFormatter`.
    ///   - label: A view that describes the use of the date.
    public init(
        _ titleKey: LocalizedStringKey,
        selection: Binding<Date>,
        minimumDate: Date,
        displayedComponents: Components = .all,
        calendar: Calendar = .current,
        dateFormatter: DateFormatter = DateFormatters.defaultFormatter,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.titleKey = titleKey
        _selection = selection
        self.minimumDate = minimumDate
        self.displayedComponents = displayedComponents.isEmpty ? .all : displayedComponents
        self.calendar = calendar

        if dateFormatter == DateFormatters.defaultFormatter && displayedComponents.contains(.hourAndMinute) {
            self.dateFormatter = DateFormatters.dateTimeFormatter
        } else {
            self.dateFormatter = dateFormatter
        }

        self.label = label
    }
}

private extension TVDatePicker {
    @ViewBuilder func navigationViewContent() -> some View {
        VStack(alignment: .leading, content: content)
            .onAppear(perform: onAppear)
            .navigationTitle(title: .init(titleKey))
            .toolbar(trailing: dismissButton())
    }

    @ViewBuilder func content() -> some View {
        Text(dateFormatter.string(from: selection)).font(.headline)

        Divider()

        Text("mm/dd/yy")
            .foregroundColor(.secondary)
            .font(.subheadline)

        if displayedComponents.contains(.year) {
            Picker(selection: $selectedYear.onChange(didChangeYear), label: Text("Year")) {
                ForEach(currentYear...(currentYear + 10), id: \.self) { year in
                    Text(String(year))
                    .tag(year)
                }
            }
            .pickerStyle(pickerStyle)
        }

        if displayedComponents.contains(.month) {
            Picker(selection: $selectedMonth.onChange(didChangeMonth), label: Text("Month")) {
                ForEach(months) { month in
                    Text(dateFormatter.shortMonthSymbols[month - 1])
                    .tag(month)
                }
            }
            .pickerStyle(pickerStyle)
        }

        if displayedComponents.contains(.date) {
            Picker(selection: $selectedDay.onChange(didChangeDay), label: Text("Day")) {
                ForEach(days) { day in
                    Text("\(day)")
                    .tag(day)
                }
            }
            .pickerStyle(pickerStyle)
        }

        if displayedComponents.contains(.hourAndMinute) {
            Text("HH:mm")
                .foregroundColor(.secondary)
                .font(.subheadline)

            Picker(selection: $selectedHour.onChange(didChangeHour), label: Text("Hour")) {
                ForEach(hours) { hour in
                    Text("\(hour)")
                    .tag(hour)
                }
            }
            .pickerStyle(pickerStyle)

            Picker(selection: $selectedMinute.onChange(didChangeMinute), label: Text("Minute")) {
                ForEach(Array(minutes), id: \.self) { minute in
                    Text("\(minute)")
                    .tag(minute)
                }
            }
            .pickerStyle(pickerStyle)
        }
    }

    func dismissButton() -> some View {
        Button(action: {
            isSheetPresented = false
        }, label: {
            Image(systemName: "xmark")
        })
    }

    func onAppear() {
        selectedYear = calendar.component(.year, from: selection)
        selectedMonth = calendar.component(.month, from: selection) - 1
        selectedDay = calendar.component(.day, from: selection) - 1
        selectedHour = calendar.component(.hour, from: selection)

        let currentMinute = calendar.component(.minute, from: selection)
        selectedMinute = currentMinute - (currentMinute % 5)
    }

    func didChangeYear(_ year: Int) {
        updateDate()
    }

    func didChangeMonth(_ month: Int) {
        updateDate()
    }

    func didChangeDay(_ day: Int) {
        updateDate()
    }

    func didChangeHour(_ hour: Int) {
        updateDate()
    }

    func didChangeMinute(_ minute: Int) {
        updateDate()
    }

    func updateDate() {
        let dateComponents = DateComponents(
            calendar: calendar,
            year: selectedYear,
            month: selectedMonth + 1,
            day: selectedDay + 1,
            hour: selectedHour,
            minute: selectedMinute
        )

        guard dateComponents.isValidDate(in: calendar) else {
            return
        }

        guard let selection = calendar.date(from: dateComponents) else {
            return
        }

        self.selection = selection
    }
}
