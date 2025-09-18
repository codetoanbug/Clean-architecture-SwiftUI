//
//  UserEntity.swift
//  Core
//
//  Created by Prank on 18/9/25.
//

import Foundation

public struct UserEntity: Sendable, Equatable {
    public let id: String
    public let username: String?
    public let fullName: String?
    public let avatarUrl: String?
    public let level: Int
    public let totalXp: Int
    public let currentStreak: Int
    public let longestStreak: Int
    public let lastActivityDate: Date?
    public let revenuecatCustomerId: String?
    public let subscriptionStatus: String?
    public let subscriptionProductId: String?
    public let subscriptionExpiresAt: Date?
    public let subscriptionStartedAt: Date?
    public let isLifetimePremium: Bool
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(
        id: String,
        username: String? = nil,
        fullName: String? = nil,
        avatarUrl: String? = nil,
        level: Int = 1,
        totalXp: Int = 0,
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        lastActivityDate: Date? = nil,
        revenuecatCustomerId: String? = nil,
        subscriptionStatus: String? = nil,
        subscriptionProductId: String? = nil,
        subscriptionExpiresAt: Date? = nil,
        subscriptionStartedAt: Date? = nil,
        isLifetimePremium: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.username = username
        self.fullName = fullName
        self.avatarUrl = avatarUrl
        self.level = level
        self.totalXp = totalXp
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.lastActivityDate = lastActivityDate
        self.revenuecatCustomerId = revenuecatCustomerId
        self.subscriptionStatus = subscriptionStatus
        self.subscriptionProductId = subscriptionProductId
        self.subscriptionExpiresAt = subscriptionExpiresAt
        self.subscriptionStartedAt = subscriptionStartedAt
        self.isLifetimePremium = isLifetimePremium
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
