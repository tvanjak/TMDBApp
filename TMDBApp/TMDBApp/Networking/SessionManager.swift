import Foundation
import Supabase
import SwiftUI

@MainActor
class SessionManager: ObservableObject {
    static let shared = SessionManager()
    
    @Published var session: Session?
    @Published var userProfile: UserProfile?
    
    private let client = SupabaseClient(
        supabaseURL: URL(string: "https://YOUR_PROJECT_ID.supabase.co")!,
        supabaseKey: "YOUR_ANON_KEY"
    )
    
    struct UserProfile: Codable {
        let id: String
        let first_name: String?
        let last_name: String?
        let phone: String?
    }
    
    private init() {
        Task { await loadSession() }
    }
    
    func loadSession() async {
        if let session = try? await client.auth.session, session.user != nil {
            self.session = session
            await loadUserProfile(userId: session.user.id.uuidString)
        } else {
            self.session = nil
            self.userProfile = nil
        }
    }
    
    func signUp(email: String, password: String, firstName: String, lastName: String, phone: String) async throws {
        let signUpResponse = try await client.auth.signUp(email: email, password: password)
        guard let user = signUpResponse.user else { return }
        
        // Insert into profiles table
        try await client.database
            .from("profiles")
            .insert([
                "id": user.id.uuidString,
                "first_name": firstName,
                "last_name": lastName,
                "phone": phone
            ])
            .execute()
        
        self.session = try? await client.auth.session
        self.userProfile = UserProfile(id: user.id.uuidString, first_name: firstName, last_name: lastName, phone: phone)
    }
    
    func signIn(email: String, password: String) async throws {
        try await client.auth.signIn(email: email, password: password)
        await loadSession()
    }
    
    func signOut() async {
        try? await client.auth.signOut()
        self.session = nil
        self.userProfile = nil
    }
    
    private func loadUserProfile(userId: String) async {
        do {
            let response = try await client.database
                .from("profiles")
                .select()
                .eq(column: "id", value: userId)
                .single()
                .execute()
            
            let profile = try JSONDecoder().decode(UserProfile.self, from: response.data)
            self.userProfile = profile
        } catch {
            print("Failed to load profile:", error)
        }
    }
}
