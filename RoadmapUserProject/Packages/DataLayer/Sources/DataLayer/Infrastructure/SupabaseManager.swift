//
//  SupabaseManager.swift
//  DataLayer
//
//  Created by Prank on 17/9/25.
//

import Foundation
import Supabase
import Auth
import PostgREST
import Realtime
import Storage

public final class SupabaseManager: Sendable {
    public static let shared = SupabaseManager()
    
    private let client: SupabaseClient
    
    private init() {
        self.client = SupabaseClient(
            supabaseURL: SupabaseConfig.url,
            supabaseKey: SupabaseConfig.anonKey
        )
    }
    
    public var supabase: SupabaseClient { client }
    
    public var auth: AuthClient {
        client.auth
    }
    
    // Table operations
    public func from(_ table: String) -> PostgrestQueryBuilder {
        client.from(table)
    }
    
    // RPC calls
//    public func rpc(_ functionName: String, params: [String: Any]? = nil) async throws -> PostgrestResponse<Data> {
//        try await client.rpc(functionName, params: params).execute()
//    }
    
    // Schema operations
    public func schema(_ schema: String) -> PostgrestClient {
        client.schema(schema)
    }
    
    // Storage operations
    public var storage: SupabaseStorageClient {
        client.storage
    }
    
    // Realtime V2
    public var realtimeV2: RealtimeClientV2 {
        client.realtimeV2
    }
    
    // Helper method for realtime channels
    public func channel(_ name: String) -> RealtimeChannelV2 {
        client.channel(name)
    }
}
