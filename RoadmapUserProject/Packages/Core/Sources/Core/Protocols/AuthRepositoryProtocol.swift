//
//  AuthRepositoryProtocol.swift
//  Core
//
//  Created by Prank on 18/9/25.
//

import Foundation

public protocol AuthRepositoryProtocol: Sendable {
    func signIn(email: String, password: String) async throws -> SessionEntity
    func signOut() async throws
    func getCurrentSession() async throws -> SessionEntity?
    func observeAuthState() -> AsyncStream<AuthState>
}

public enum AuthState: Sendable {
    case signedIn(SessionEntity)
    case signedOut
    case unknown
}
