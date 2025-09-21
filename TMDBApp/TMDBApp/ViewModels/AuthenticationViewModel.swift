//
//  AuthenticationViewModel.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 16.08.2025..
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor
final class AuthenticationViewModel: ObservableObject {
    private let authenticationRepository: AuthenticationRepositoryProtocol
//    private var cancellables = Set<AnyCancellable>()

    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phoneNumber: String = ""
    @Published var confirmPassword: String = ""

    @Published var errorMessage: String?
    @Published private(set) var currentUser: User?

    init(authenticationRepository: AuthenticationRepositoryProtocol) {
        self.authenticationRepository = authenticationRepository
        authenticationRepository.currentUserPublisher
            .assign(to: &$currentUser)
    }

    func signIn() async {
        do {
            try await authenticationRepository.signIn(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signUp() async {
        do {
            try await authenticationRepository.signUp(email: email, password: password, confirmPassword: confirmPassword, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signOut() {
        do {
            try authenticationRepository.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
