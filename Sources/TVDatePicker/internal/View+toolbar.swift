//
//  View+toolbar.swift
//  TVDatePicker
//
//  Created by Christian Elies on 20.12.20.
//

import SwiftUI

extension View {
    func toolbar<Leading: View>(leading: Leading) -> some View {
        toolbar(leading: leading, trailing: EmptyView())
    }

    func toolbar<Trailing: View>(trailing: Trailing) -> some View {
        toolbar(leading: EmptyView(), trailing: trailing)
    }

    @ViewBuilder func toolbar<Leading: View, Trailing: View>(leading: Leading, trailing: Trailing) -> some View {
        if #available(tvOS 14, *) {
            self.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    leading
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailing
                }
            }
        } else {
            self.navigationBarItems(leading: leading, trailing: trailing)
        }
    }
}
