//
//  SessionRepository.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 29.08.2025..
//

import SwiftUI
import FirebaseAuth

protocol SessionRepositoryProtocol {
    var currentUserId: String? { get }
}

class SessionRepository: SessionRepositoryProtocol {
//    static let shared = SessionRepository()
//    private init() {}
    
    private let auth = Auth.auth()
    var currentUserId: String? {
        auth.currentUser?.uid
    }
}
