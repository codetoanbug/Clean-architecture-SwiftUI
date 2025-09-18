//
//  SupabaseConfig.swift
//  DataLayer
//
//  Created by Prank on 17/9/25.
//

import Foundation

public enum SupabaseConfig {
    // Development config
    #if DEBUG
    public static let url = URL(string: "http://127.0.0.1:54321")!
    public static let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0"
    #else
    // Production config
    public static let url = URL(string: "https://your-project.supabase.co")!
    public static let anonKey = "your-production-anon-key"
    #endif
}
