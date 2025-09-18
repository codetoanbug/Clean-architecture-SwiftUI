//
//  SessionEntity.swift
//  Core
//
//  Created by Prank on 18/9/25.
//

import Foundation

public struct SessionEntity: Sendable {
    public let userId: String
    public let accessToken: String
    public let refreshToken: String?
    public let expiresAt: Date?
    
    public init(
        userId: String,
        accessToken: String,
        refreshToken: String? = nil,
        expiresAt: Date? = nil
    ) {
        self.userId = userId
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresAt = expiresAt
    }
}
