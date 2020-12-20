//
//  TVDatePicker.swift
//  TVDatePicker
//
//  Created by Christian Elies on 20.12.20.
//  Copyright © 2020 Christian Elies. All rights reserved.
//

import SwiftUI

/// <#Description#>
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

    @State private var isSheetPresented = false
    @State private var selectedYear: Int = 0
    @State private var selectedMonth: Int = 0
    @State private var selectedDay: Int = 0

    // MARK: - Internal
    var titleKey: LocalizedStringKey
    @Binding var selection: Date
    var minimumDate: Date
    var displayedComponents: Components
    var calendar: Calendar = .current
    var dateFormatter: DateFormatter
    var label: () -> Label

    // MARK: - Public

    /// <#Description#>
    public struct Components: OptionSet {
        /// <#Description#>
        public static var year: Components { Components(rawValue: 1) }
        /// <#Description#>
        public static var month: Components { Components(rawValue: 1 << 1) }
        /// <#Description#>
        public static var date: Components { Components(rawValue: 1 << 2) }
        /// <#Description#>
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
                    NavigationView {
                        content()
                            .navigationTitle(title: .init(titleKey))
                            .toolbar(trailing: Button(action: {
                                isSheetPresented = false
                            }, label: {
                                Image(systemName: "xmark")
                            }))
                    }
                }
        )
    }

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - titleKey: <#titleKey description#>
    ///   - selection: <#selection description#>
    ///   - minimumDate: <#minimumDate description#>
    ///   - displayedComponents: <#displayedComponents description#>
    ///   - calendar: <#calendar description#>
    ///   - dateFormatter: <#formatter description#>
    ///   - label: <#title description#>
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
        self.displayedComponents = displayedComponents
        self.calendar = calendar
        self.dateFormatter = dateFormatter
        self.label = label
    }
}

private extension TVDatePicker {
    func content() -> some View {
        List {
            Text(dateFormatter.string(from: selection)).font(.title)

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
        }
        .onAppear(perform: onAppear)
    }

    func onAppear() {
        selectedYear = calendar.component(.year, from: selection)
        selectedMonth = calendar.component(.month, from: selection) - 1
        selectedDay = calendar.component(.day, from: selection) - 1
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

    func updateDate() {
        let dateComponents = DateComponents(calendar: calendar, year: selectedYear, month: selectedMonth + 1, day: selectedDay + 1)

        guard dateComponents.isValidDate(in: calendar) else {
            return
        }

        guard let selection = calendar.date(from: dateComponents) else {
            return
        }

        self.selection = selection
    }
}
