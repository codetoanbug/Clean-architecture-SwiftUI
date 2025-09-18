//
//  UserViewModel.swift
//  Presentation
//
//  Created by Prank on 18/9/25.
//

import Foundation
import Core

public struct UserViewModel {
    public let id: String
    public let username: String?
    public let fullName: String?
    public let avatarUrl: String?
    public let level: Int
    public let totalXp: Int
    public let currentStreak: Int
    public let longestStreak: Int
    public let isLifetimePremium: Bool
    
    public var displayName: String {
        fullName ?? username ?? "User"
    }
    
    public var levelText: String {
        "Level \(level)"
    }
    
    public var xpText: String {
        "\(totalXp) XP"
    }
    
    public var currentStreakText: String {
        "\(currentStreak) days"
    }
    
    public var longestStreakText: String {
        "\(longestStreak) days"
    }
    
    init(from entity: UserEntity) {
        self.id = entity.id
        self.username = entity.username
        self.fullName = entity.fullName
        self.avatarUrl = entity.avatarUrl
        self.level = entity.level
        self.totalXp = entity.totalXp
        self.currentStreak = entity.currentStreak
        self.longestStreak = entity.longestStreak
        self.isLifetimePremium = entity.isLifetimePremium
    }
}
