//
//  UserMapper.swift
//  DataLayer
//
//  Created by Prank on 18/9/25.
//

import Foundation
import Core

extension UserDTO {
    func toEntity() -> UserEntity {
        let dateFormatter = ISO8601DateFormatter()
        
        return UserEntity(
            id: id,
            username: username,
            fullName: fullName,
            avatarUrl: avatarUrl,
            level: level,
            totalXp: totalXp,
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            lastActivityDate: lastActivityDate.flatMap { dateFormatter.date(from: $0) },
            revenuecatCustomerId: revenuecatCustomerId,
            subscriptionStatus: subscriptionStatus,
            subscriptionProductId: subscriptionProductId,
            subscriptionExpiresAt: subscriptionExpiresAt.flatMap { dateFormatter.date(from: $0) },
            subscriptionStartedAt: subscriptionStartedAt.flatMap { dateFormatter.date(from: $0) },
            isLifetimePremium: isLifetimePremium,
            createdAt: dateFormatter.date(from: createdAt) ?? Date(),
            updatedAt: dateFormatter.date(from: updatedAt) ?? Date()
        )
    }
    
    static func fromEntity(_ entity: UserEntity) -> UserDTO {
        let dateFormatter = ISO8601DateFormatter()
        
        return UserDTO(
            id: entity.id,
            username: entity.username,
            fullName: entity.fullName,
            avatarUrl: entity.avatarUrl,
            level: entity.level,
            totalXp: entity.totalXp,
            currentStreak: entity.currentStreak,
            longestStreak: entity.longestStreak,
            lastActivityDate: entity.lastActivityDate.map { dateFormatter.string(from: $0) },
            revenuecatCustomerId: entity.revenuecatCustomerId,
            subscriptionStatus: entity.subscriptionStatus,
            subscriptionProductId: entity.subscriptionProductId,
            subscriptionExpiresAt: entity.subscriptionExpiresAt.map { dateFormatter.string(from: $0) },
            subscriptionStartedAt: entity.subscriptionStartedAt.map { dateFormatter.string(from: $0) },
            isLifetimePremium: entity.isLifetimePremium,
            createdAt: dateFormatter.string(from: entity.createdAt),
            updatedAt: dateFormatter.string(from: entity.updatedAt)
        )
    }
}
