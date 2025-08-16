//
//  Header.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI

struct HeaderView: View {
    
    var body: some View {
        HStack {
            Spacer()
            Text("TMDB")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 154/255, green: 203/255, blue: 165/255)
,                             Color(red: 76/255, green: 178/255, blue: 223/255)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 154/255, green: 203/255, blue: 165/255)
,                             Color(red: 76/255, green: 178/255, blue: 223/255)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 80, height: 30)
            Spacer()
        }
        .padding()
        .background(Color(red: 11/255, green: 37/255, blue: 63/255))
    }
}


#Preview {
    HeaderView()
}
