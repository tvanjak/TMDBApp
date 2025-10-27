//
//  AuthenticationTextField.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 16.09.2025..
//

import SwiftUI

struct AuthenticationTextField: View {
    @Binding var text: String
    var subtitle: String
    var placeholder: String
    var secure: Bool
    
    var forgotPasswordAction: (() -> Void)?

    var body: some View {
        VStack (alignment: .leading){
            HStack {
                Text(subtitle)
                    .foregroundStyle(.white)
                    .font(AppTheme.Typography.body)
                if let optionalFunction = forgotPasswordAction {
                    Button("Forgot your password?", action: optionalFunction)
                        .padding(.leading, 90)
                        .foregroundColor(AppTheme.Colors.lightBlue)
                }
            }
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: AppTheme.Radius.small)
                    .fill(AppTheme.Colors.darkBlue)
                
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(AppTheme.Colors.lightBlue)
                        .font(AppTheme.Typography.subtitle)
                        .padding(.horizontal)
                }
                
                if secure {
                    SecureField("", text: $text)
                        .foregroundStyle(.white)
                        .font(AppTheme.Typography.subtitle)
                        .padding(.horizontal, AppTheme.Spacing.medium)
                } else {
                    TextField("", text: $text)
                        .foregroundStyle(.white)
                        .font(AppTheme.Typography.subtitle)
                        .padding(.horizontal, AppTheme.Spacing.medium)
                }
            }
            .frame(height: 55)
            .frame(maxWidth: .infinity)
        } .padding(.horizontal)

    }
}
