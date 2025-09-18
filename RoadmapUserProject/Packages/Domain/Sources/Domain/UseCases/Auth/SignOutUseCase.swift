//
//  SignOutUseCase.swift
//  Domain
//
//  Created by Prank on 18/9/25.
//

import Foundation
import Core

public final class SignOutUseCase: Sendable {
    private let authRepository: AuthRepositoryProtocol
    
    public init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
    
    public func execute() async throws {
        try await authRepository.signOut()
    }
}
