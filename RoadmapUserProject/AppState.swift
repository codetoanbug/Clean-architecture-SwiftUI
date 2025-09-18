//
//  AppState.swift
//  RoadmapUserProject
//
//  Created by Prank on 17/9/25.
//

import SwiftUI
import Combine
import Core
import DataLayer

@MainActor
final class AppState: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false

    init() {
        
    }
    
    func login(user: User) {
       
    }
    
    func logout() {

    }
}
