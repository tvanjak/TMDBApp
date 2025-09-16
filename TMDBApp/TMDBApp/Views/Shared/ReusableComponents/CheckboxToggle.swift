//
//  CheckboxToggle.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 16.09.2025..
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(.blue) // Customize color
                    .font(AppTheme.Typography.title2)
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
