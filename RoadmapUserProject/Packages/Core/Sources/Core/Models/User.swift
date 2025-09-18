//
//  User.swift
//  Core
//
//  Created by Prank on 18/9/25.
//

import Foundation

// MARK: - Models
public nonisolated struct User: Codable, Sendable {
    public let id: String
    public let username: String?
    public let fullName: String?
    public let avatarUrl: String?
    public let level: Int
    public let totalXp: Int
    public let currentStreak: Int
    public let longestStreak: Int
    public let lastActivityDate: String?
    public let revenuecatCustomerId: String?
    public let subscriptionStatus: String?
    public let subscriptionProductId: String?
    public let subscriptionExpiresAt: String?
    public let subscriptionStartedAt: String?
    public  let isLifetimePremium: Bool
    public let createdAt: String
    public let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case fullName = "full_name"
        case avatarUrl = "avatar_url"
        case level
        case totalXp = "total_xp"
        case currentStreak = "current_streak"
        case longestStreak = "longest_streak"
        case lastActivityDate = "last_activity_date"
        case revenuecatCustomerId = "revenuecat_customer_id"
        case subscriptionStatus = "subscription_status"
        case subscriptionProductId = "subscription_product_id"
        case subscriptionExpiresAt = "subscription_expires_at"
        case subscriptionStartedAt = "subscription_started_at"
        case isLifetimePremium = "is_lifetime_premium"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
