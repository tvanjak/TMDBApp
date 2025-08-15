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
            Text("TMDBApp")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
            Spacer()
            Image(systemName: "person.circle")
                .font(.title)
                .foregroundStyle(Color(red: 76/255, green: 178/255, blue: 223/255))
        }
        .padding()
        .background(Color(red: 11/255, green: 37/255, blue: 63/255))
    }
}
//#0B253F


#Preview {
    HeaderView()
}
