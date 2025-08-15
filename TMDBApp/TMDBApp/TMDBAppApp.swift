//
//  TMDBAppApp.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 11.08.2025..
//

import SwiftUI

@main
struct TMDBAppApp: App {
    @StateObject private var session = SessionManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(session)
                .onAppear {
                    session.restoreSession()
                }
        }
    }
}
