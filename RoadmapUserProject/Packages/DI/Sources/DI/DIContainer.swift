//
//  DIContainer.swift
//  DI
//
//  Created by Prank on 18/9/25.
//

import Foundation
import Core
import Domain
import DataLayer
import Presentation

public final class DIContainer: Sendable {
    public static let shared = DIContainer()
    
    private init() {}
    
    // MARK: - Repositories
    private nonisolated(unsafe) var _authRepository: AuthRepositoryProtocol?
    public var authRepository: AuthRepositoryProtocol {
        if _authRepository == nil {
            _authRepository = AuthRepository()
        }
        return _authRepository!
    }
    
    private nonisolated(unsafe) var _userRepository: UserRepositoryProtocol?
    public var userRepository: UserRepositoryProtocol {
        if _userRepository == nil {
            _userRepository = UserRepository()
        }
        return _userRepository!
    }
    
    // MARK: - Use Cases
    public var signInUseCase: SignInUseCase {
        SignInUseCase(
            authRepository: authRepository,
            userRepository: userRepository
        )
    }
    
    public var signOutUseCase: SignOutUseCase {
        SignOutUseCase(authRepository: authRepository)
    }
    
    public var getCurrentUserUseCase: GetCurrentUserUseCase {
        GetCurrentUserUseCase(
            authRepository: authRepository,
            userRepository: userRepository
        )
    }
    
    public var observeAuthStateUseCase: ObserveAuthStateUseCase {
        ObserveAuthStateUseCase(
            authRepository: authRepository,
            userRepository: userRepository
        )
    }
    
    // MARK: - ViewModels
    @MainActor
    public func makeAuthViewModel() -> AuthViewModel {
        AuthViewModel(
            signInUseCase: signInUseCase,
            signOutUseCase: signOutUseCase,
            getCurrentUserUseCase: getCurrentUserUseCase,
            observeAuthStateUseCase: observeAuthStateUseCase
        )
    }
}
