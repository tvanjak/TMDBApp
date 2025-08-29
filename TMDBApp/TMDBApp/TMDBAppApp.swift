//
//  TMDBAppApp.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 11.08.2025..
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure() // Configure Firebase
    print("Firebase has been configured!")
    return true
  }
}

@main
struct TMDBApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthenticationViewModel()
    @StateObject var movieViewModel = MovieViewModel()
    @StateObject var tvShowViewModel = TVShowViewModel()
    @StateObject var router = Router()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(router)
                .environmentObject(movieViewModel)
                .environmentObject(tvShowViewModel)
        }
    }
}
