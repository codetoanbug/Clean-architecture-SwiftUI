//
//  UserRepository.swift
//  DataLayer
//
//  Created by Prank on 18/9/25.
//

import Foundation
import Core
import Supabase

public final class UserRepository: UserRepositoryProtocol {
    private let supabaseClient: SupabaseClient
    
    public init() {
        self.supabaseClient = SupabaseClientManager.shared.client
    }
    
    public func fetchUser(userId: String) async throws -> UserEntity {
        do {
            let response = try await supabaseClient
                .from("profiles")
                .select()
                .eq("id", value: userId)
                .single()
                .execute()
            
            let userDTO = try JSONDecoder().decode(UserDTO.self, from: response.data)
            return userDTO.toEntity()
        } catch {
            throw DomainError.userNotFound
        }
    }
    
    public func updateUser(_ user: UserEntity) async throws -> UserEntity {
        do {
            let userDTO = UserDTO.fromEntity(user)
            let data = try JSONEncoder().encode(userDTO)
            
            let response = try await supabaseClient
                .from("profiles")
                .update(data)
                .eq("id", value: user.id)
                .single()
                .execute()
            
            let updatedDTO = try JSONDecoder().decode(UserDTO.self, from: response.data)
            return updatedDTO.toEntity()
        } catch {
            throw DomainError.networkError(error.localizedDescription)
        }
    }
    
    public func deleteUser(userId: String) async throws {
        do {
            _ = try await supabaseClient
                .from("profiles")
                .delete()
                .eq("id", value: userId)
                .execute()
        } catch {
            throw DomainError.networkError(error.localizedDescription)
        }
    }
}
