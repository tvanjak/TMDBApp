//
//  Header.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI

struct HeaderView: View {
    var canGoBack: Bool = false
    var onBack: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            if canGoBack {
                Button(action: { onBack?() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(height: 30)
                }
            }
            
            Spacer()
            Text("TMDB")
                .font(AppTheme.Typography.largeTitle)
                .bold()
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            AppTheme.Colors.lightGreen,
                            AppTheme.Colors.lightBlue
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            RoundedRectangle(cornerRadius: AppTheme.Radius.medium)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            AppTheme.Colors.lightGreen,
                            AppTheme.Colors.lightBlue
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 80, height: 30)
            Spacer()
            
            if canGoBack {
                Color.clear.frame(width: 30, height: 30)
            }
        }
        .padding()
        .background(AppTheme.Colors.background)
    }
}


#Preview {
    HeaderView()
}
