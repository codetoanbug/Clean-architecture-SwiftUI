//
//  GetCurrentUserUseCase.swift
//  Domain
//
//  Created by Prank on 18/9/25.
//

import Foundation
import Core

public final class GetCurrentUserUseCase: Sendable {
    private let authRepository: AuthRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    
    public init(
        authRepository: AuthRepositoryProtocol,
        userRepository: UserRepositoryProtocol
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
    public func execute() async throws -> UserEntity? {
        guard let session = try await authRepository.getCurrentSession() else {
            return nil
        }
        
        return try await userRepository.fetchUser(userId: session.userId)
    }
}
