//
//  RoadmapUserProjectApp.swift
//  RoadmapUserProject
//
//  Created by Prank on 17/9/25.
//

import SwiftUI
import DataLayer

@main
struct RoadmapUserProjectApp: App {
    @StateObject private var authManager = AuthManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
        }
    }
}
