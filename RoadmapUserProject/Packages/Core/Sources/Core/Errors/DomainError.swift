//
//  DomainError.swift
//  Core
//
//  Created by Prank on 18/9/25.
//

import Foundation

public enum DomainError: LocalizedError, Sendable {
    case invalidCredentials
    case userNotFound
    case networkError(String)
    case unauthorized
    case unknown(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .userNotFound:
            return "User not found"
        case .networkError(let message):
            return "Network error: \(message)"
        case .unauthorized:
            return "Unauthorized access"
        case .unknown(let message):
            return "Unknown error: \(message)"
        }
    }
}
