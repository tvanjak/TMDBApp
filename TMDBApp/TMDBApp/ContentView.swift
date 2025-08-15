//
//  ContentView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 11.08.2025..
//

import SwiftUI

struct ContentView: View {
    @StateObject private var session: SessionManager.shared

    var body: some View {
        if session.session != nil {
            AppLayout()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
