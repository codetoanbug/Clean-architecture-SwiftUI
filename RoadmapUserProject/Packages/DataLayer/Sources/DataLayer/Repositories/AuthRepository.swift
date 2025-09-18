//
//  AuthRepository.swift
//  DataLayer
//
//  Created by Prank on 18/9/25.
//

import Foundation
import Core
import Supabase
import Auth

public final class AuthRepository: AuthRepositoryProtocol {
    private let supabaseClient: SupabaseClient
    
    public init() {
        self.supabaseClient = SupabaseClientManager.shared.client
    }
    
    public func signIn(email: String, password: String) async throws -> SessionEntity {
        do {
            let session = try await supabaseClient.auth.signIn(
                email: email,
                password: password
            )
            
            return SessionEntity(
                userId: session.user.id.uuidString,
                accessToken: session.accessToken,
                refreshToken: session.refreshToken,
                expiresAt: Date(timeIntervalSince1970: TimeInterval(session.expiresAt))
            )
        } catch {
            throw DomainError.invalidCredentials
        }
    }
    
    public func signOut() async throws {
        do {
            try await supabaseClient.auth.signOut()
        } catch {
            throw DomainError.unknown(error.localizedDescription)
        }
    }
    
    public func getCurrentSession() async throws -> SessionEntity? {
        do {
            let session = try await supabaseClient.auth.session
            
            return SessionEntity(
                userId: session.user.id.uuidString,
                accessToken: session.accessToken,
                refreshToken: session.refreshToken,
                expiresAt: Date(timeIntervalSince1970: TimeInterval(session.expiresAt))
            )
        } catch {
            return nil
        }
    }
    
    public func observeAuthState() -> AsyncStream<AuthState> {
        AsyncStream { continuation in
            Task {
                for await (event, session) in supabaseClient.auth.authStateChanges {
                    switch event {
                    case .initialSession, .signedIn, .tokenRefreshed:
                        if let session = session {
                            let sessionEntity = SessionEntity(
                                userId: session.user.id.uuidString,
                                accessToken: session.accessToken,
                                refreshToken: session.refreshToken,
                                expiresAt: Date(timeIntervalSince1970: TimeInterval(session.expiresAt))
                            )
                            continuation.yield(.signedIn(sessionEntity))
                        } else {
                            continuation.yield(.signedOut)
                        }
                    case .signedOut:
                        continuation.yield(.signedOut)
                    default:
                        continuation.yield(.unknown)
                    }
                }
            }
        }
    }
}
