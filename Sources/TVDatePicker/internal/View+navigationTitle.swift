//
//  View+navigationTitle.swift
//  TVDatePicker
//
//  Created by Christian Elies on 20.12.20.
//

import SwiftUI

@available(iOS, unavailable)
extension View {
    @ViewBuilder func navigationTitle(title: Text) -> some View {
        if #available(tvOS 14, *) {
            self.navigationTitle(title)
        } else {
            self.navigationBarTitle(title)
        }
    }
}
