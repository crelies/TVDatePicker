//
//  Binding+onChange.swift
//  TVDatePicker
//
//  Created by Christian Elies on 20.12.20.
//

import SwiftUI

@available(iOS, unavailable)
extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { selection in
                wrappedValue = selection
                handler(selection)
        })
    }
}
