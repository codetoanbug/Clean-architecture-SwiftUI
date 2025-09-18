//
//  UserDTO.swift
//  DataLayer
//
//  Created by Prank on 18/9/25.
//

import Foundation

struct UserDTO: Codable, Sendable {
    let id: String
    let username: String?
    let fullName: String?
    let avatarUrl: String?
    let level: Int
    let totalXp: Int
    let currentStreak: Int
    let longestStreak: Int
    let lastActivityDate: String?
    let revenuecatCustomerId: String?
    let subscriptionStatus: String?
    let subscriptionProductId: String?
    let subscriptionExpiresAt: String?
    let subscriptionStartedAt: String?
    let isLifetimePremium: Bool
    let createdAt: String
    let updatedAt: String
    
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
