//
//  SupabaseClient+Extension..swift
//  DataLayer
//
//  Created by Prank on 18/9/25.
//

import Foundation
import Supabase

final class SupabaseClientManager: Sendable {
    static let shared = SupabaseClientManager()
    
    let client: SupabaseClient
    
    private init() {
        self.client = SupabaseClient(
            supabaseURL: SupabaseConfig.url,
            supabaseKey: SupabaseConfig.anonKey
        )
    }
}
