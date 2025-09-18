//
//  AuthViewModel.swift
//  Presentation
//
//  Created by Prank on 18/9/25.
//

import Foundation
import SwiftUI
import Core
import Domain

@MainActor
public final class AuthViewModel: ObservableObject {
    @Published public private(set) var isAuthenticated = false
    @Published public private(set) var currentUser: UserViewModel?
    @Published public private(set) var isLoading = false
    @Published public var alertItem: AlertItem?  // ✅ Sử dụng AlertItem
    
    private let signInUseCase: SignInUseCase
    private let signOutUseCase: SignOutUseCase
    private let getCurrentUserUseCase: GetCurrentUserUseCase
    private let observeAuthStateUseCase: ObserveAuthStateUseCase
    
    private var authStateTask: Task<Void, Never>?
    
    public init(
        signInUseCase: SignInUseCase,
        signOutUseCase: SignOutUseCase,
        getCurrentUserUseCase: GetCurrentUserUseCase,
        observeAuthStateUseCase: ObserveAuthStateUseCase
    ) {
        self.signInUseCase = signInUseCase
        self.signOutUseCase = signOutUseCase
        self.getCurrentUserUseCase = getCurrentUserUseCase
        self.observeAuthStateUseCase = observeAuthStateUseCase
        
        setupAuthStateObserver()
        checkInitialAuthState()
    }
    
    deinit {
        authStateTask?.cancel()
    }
    
    private func setupAuthStateObserver() {
        authStateTask = Task { [weak self] in
            for await state in self?.observeAuthStateUseCase.execute() ?? AsyncStream { _ in } {
                guard let self = self else { break }
                
                await MainActor.run {
                    switch state {
                    case .authenticated(let userEntity):
                        self.currentUser = UserViewModel(from: userEntity)
                        self.isAuthenticated = true
                        self.clearError()
                    case .unauthenticated:
                        self.currentUser = nil
                        self.isAuthenticated = false
                    case .error(let error):
                        self.showError(error.localizedDescription)
                    case .unknown:
                        break
                    }
                }
            }
        }
    }
    
    private func checkInitialAuthState() {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                if let userEntity = try await getCurrentUserUseCase.execute() {
                    self.currentUser = UserViewModel(from: userEntity)
                    self.isAuthenticated = true
                }
            } catch {
                debugPrint("Initial auth check: \(error.localizedDescription)")
            }
        }
    }
    
    public func signIn(email: String, password: String) async {
        await MainActor.run {
            isLoading = true
            clearError()
        }
        
        do {
            let (_, userEntity) = try await signInUseCase.execute(email: email, password: password)
            
            await MainActor.run {
                self.currentUser = UserViewModel(from: userEntity)
                self.isAuthenticated = true
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.showError(error.localizedDescription)
                self.isLoading = false
            }
        }
    }
    
    public func signOut() async {
        await MainActor.run {
            isLoading = true
            clearError()
        }
        
        do {
            try await signOutUseCase.execute()
            
            await MainActor.run {
                self.currentUser = nil
                self.isAuthenticated = false
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.showError(error.localizedDescription)
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Error Handling
    private func showError(_ message: String, title: String = "Error") {
        alertItem = AlertItem(
            title: title,
            message: message,
            dismissButton: "OK"
        )
    }
    
    private func clearError() {
        alertItem = nil
    }
}
