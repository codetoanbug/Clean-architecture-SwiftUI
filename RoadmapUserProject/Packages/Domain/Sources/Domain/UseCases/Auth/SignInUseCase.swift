//
//  SignInUseCase.swift
//  Domain
//
//  Created by Prank on 18/9/25.
//

import Foundation
import Core

public final class SignInUseCase: Sendable {
    private let authRepository: AuthRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    
    public init(
        authRepository: AuthRepositoryProtocol,
        userRepository: UserRepositoryProtocol
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
    public func execute(email: String, password: String) async throws -> (session: SessionEntity, user: UserEntity) {
        // Validate input
        guard !email.isEmpty, email.contains("@") else {
            throw DomainError.invalidCredentials
        }
        
        guard !password.isEmpty, password.count >= 6 else {
            throw DomainError.invalidCredentials
        }
        
        // Sign in
        let session = try await authRepository.signIn(email: email, password: password)
        
        // Fetch user profile
        let user = try await userRepository.fetchUser(userId: session.userId)
        
        return (session, user)
    }
}
