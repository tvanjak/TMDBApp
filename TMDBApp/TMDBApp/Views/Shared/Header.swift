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
                .font(.largeTitle)
                .bold()
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 154/255, green: 203/255, blue: 165/255),
                            Color(red: 76/255, green: 178/255, blue: 223/255)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 154/255, green: 203/255, blue: 165/255),
                            Color(red: 76/255, green: 178/255, blue: 223/255)
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
        .background(Color(red: 11/255, green: 37/255, blue: 63/255))
    }
}


#Preview {
    HeaderView()
}
