//
//  DateFormatters.swift
//  TVDatePicker
//
//  Created by Christian Elies on 20.12.20.
//  Copyright © 2020 Christian Elies. All rights reserved.
//

import Foundation

@available(iOS, unavailable)
/// Helper type which manages the default date formatter used by the date picker view.
public enum DateFormatters {
    /// The default date formatter which uses the `short` date style and `none` time style.
    public static var defaultFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()

    /// A date time formatter which uses the `short` date style and `short` time style.
    public static var dateTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
}
