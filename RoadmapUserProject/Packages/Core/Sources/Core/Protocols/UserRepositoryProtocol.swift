//
//  UserRepositoryProtocol.swift
//  Core
//
//  Created by Prank on 18/9/25.
//

import Foundation

public protocol UserRepositoryProtocol: Sendable {
    func fetchUser(userId: String) async throws -> UserEntity
    func updateUser(_ user: UserEntity) async throws -> UserEntity
    func deleteUser(userId: String) async throws
}
