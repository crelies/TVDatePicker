//
//  DateFormatters.swift
//  TVDatePicker
//
//  Created by Christian Elies on 20.12.20.
//  Copyright © 2020 Christian Elies. All rights reserved.
//

import Foundation

/// <#Description#>
public enum DateFormatters {
    /// <#Description#>
    public static var defaultFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
}
