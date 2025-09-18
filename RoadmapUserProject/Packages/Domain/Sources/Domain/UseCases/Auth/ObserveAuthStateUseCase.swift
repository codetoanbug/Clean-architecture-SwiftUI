//
//  ObserveAuthStateUseCase.swift
//  Domain
//
//  Created by Prank on 18/9/25.
//

import Foundation
import Core

public final class ObserveAuthStateUseCase: Sendable {
    private let authRepository: AuthRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    
    public init(
        authRepository: AuthRepositoryProtocol,
        userRepository: UserRepositoryProtocol
    ) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }
    
    public func execute() -> AsyncStream<AuthStateResult> {
        AsyncStream { continuation in
            Task {
                for await state in authRepository.observeAuthState() {
                    switch state {
                    case .signedIn(let session):
                        do {
                            let user = try await userRepository.fetchUser(userId: session.userId)
                            continuation.yield(.authenticated(user))
                        } catch {
                            continuation.yield(.error(error))
                        }
                    case .signedOut:
                        continuation.yield(.unauthenticated)
                    case .unknown:
                        continuation.yield(.unknown)
                    }
                }
            }
        }
    }
}

public enum AuthStateResult: Sendable {
    case authenticated(UserEntity)
    case unauthenticated
    case unknown
    case error(Error)
}
