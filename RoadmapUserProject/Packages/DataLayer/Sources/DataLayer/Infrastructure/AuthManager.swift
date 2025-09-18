//
//  AuthManager.swift
//  DataLayer
//
//  Created by Prank on 17/9/25.
//

import Foundation
import Combine
import Supabase
import Core

public typealias User = Core.User

@MainActor
public class AuthManager: ObservableObject {
    public static let shared = AuthManager()
   
    
    @Published public var isAuthenticated = false
    @Published public var currentUser: User?
    
    private var authListenerTask: Task<Void, Never>?
    
    private init() {
        setupAuthListener()
        checkAuthentication()
    }
    
    private func setupAuthListener() {
        authListenerTask = Task(priority: .background) { [weak self] in
            let stream = SupabaseManager.shared.supabase.auth.authStateChanges
            
            for await (event, session) in stream {
                guard let self = self else { break }
                
                await self.processAuthChange(event: event, session: session)
            }
        }
    }
    
    @MainActor
    private func processAuthChange(event: AuthChangeEvent, session: Session?) async {
        switch event {
        case .initialSession, .signedIn:
            if let session = session {
                await handleSignIn(session: session)
            }
        case .signedOut:
            handleSignOut()
        case .userUpdated:
            if let session = session {
                await handleSignIn(session: session)
            }
        default:
            break
        }
    }
    
    public func checkAuthentication() {
        Task {
            do {
                let session = try await SupabaseManager.shared.auth.session
                await handleSignIn(session: session)
            } catch {
                debugPrint("No active session: \(error)")
                handleSignOut()
            }
        }
    }
    
    private func handleSignIn(session: Session?) async {
        guard let session = session else { return }
        
        do {
            // Fetch user profile
            let userProfile = try await fetchUserProfile(userId: session.user.id.uuidString)
            
            // Update state
            self.currentUser = userProfile
            self.isAuthenticated = true
        } catch {
            debugPrint("Error fetching user data: \(error)")
            handleSignOut()
        }
    }
    
    private func handleSignOut() {
        self.isAuthenticated = false
        self.currentUser = nil
    }
    
    nonisolated private func fetchUserProfile(userId: String) async throws -> User {
        // Dùng from() thay vì database.from()
        let response = try await SupabaseManager.shared
            .from("profiles")
            .select()
            .eq("id", value: userId)
            .single()
            .execute()
        
        return try JSONDecoder().decode(User.self, from: response.data)
    }
    
    public func signIn(email: String, password: String) async throws {
        let session = try await SupabaseManager.shared.auth.signIn(
            email: email,
            password: password
        )
        
        await handleSignIn(session: session)
    }
    
    public func signOut() async throws {
        try await SupabaseManager.shared.auth.signOut()
        handleSignOut()
    }
}

// Auth Error
public enum AuthError: LocalizedError {
    case invalidCredentials
    case networkError
    
    public var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .networkError:
            return "Network connection error"
        }
    }
}
