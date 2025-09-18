//
//  ContentView.swift
//  RoadmapUserProject
//
//  Created by Prank on 17/9/25.
//

import SwiftUI
import Presentation
import Common
import DI

struct ContentView: View {
    @StateObject private var authViewModel = DIContainer.shared.makeAuthViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                HomeView()
                    .environmentObject(authViewModel)
            } else {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
        .overlay {
            if authViewModel.isLoading {
                LoadingOverlay()
            }
        }
        .alert(item: $authViewModel.alertItem) { alertItem in
            Alert(
                title: Text(alertItem.title),
                message: Text(alertItem.message),
                dismissButton: .default(Text(alertItem.dismissButton))
            )
        }
    }
}

// MARK: - Loading Overlay
struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                
                Text("Loading...")
                    .foregroundColor(.white)
                    .font(.headline)
            }
            .padding(30)
            .background(Color.black.opacity(0.7))
            .cornerRadius(15)
        }
    }
}

// MARK: - Login View with Common Components
struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Logo or App Icon
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .padding(.top, 50)
                    
                    // Welcome Text
                    VStack(spacing: 10) {
                        Text("Welcome Back")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Sign in to continue")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 20)
                    
                    // Form Fields using Common Components
                    VStack(spacing: 20) {
                        // Email Field
                        CustomTextField(
                            placeholder: "Email",
                            text: $email,
                            isSecure: false
                        )
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($focusedField, equals: .email)
                        .onSubmit {
                            focusedField = .password
                        }
                        
                        // Password Field
                        CustomTextField(
                            placeholder: "Password",
                            text: $password,
                            isSecure: true
                        )
                        .focused($focusedField, equals: .password)
                        .onSubmit {
                            signIn()
                        }
                        
                        // Forgot Password
                        HStack {
                            Spacer()
                            Button("Forgot Password?") {
                                // Handle forgot password
                            }
                            .font(.footnote)
                            .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Sign In Button using PrimaryButton
                    PrimaryButton(
                        title: "Sign In",
                        isLoading: authViewModel.isLoading,
                        action: signIn
                    )
                    .padding(.horizontal, 20)
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? 1.0 : 0.6)
                    
                    // Sign Up Link
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.secondary)
                        Button("Sign Up") {
                            // Handle sign up navigation
                        }
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    }
                    .font(.footnote)
                    
                    Spacer(minLength: 50)
                }
            }
            .navigationBarHidden(true)
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
    
    private var isFormValid: Bool {
        !email.isEmpty && email.contains("@") && password.count >= 6
    }
    
    private func signIn() {
        guard isFormValid else { return }
        
        Task {
            await authViewModel.signIn(email: email, password: password)
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Home View with Better UI
struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ProfileTab()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(0)
                .environmentObject(authViewModel)
            
            StatsTab()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
                .tag(1)
                .environmentObject(authViewModel)
            
            SettingsTab()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
                .environmentObject(authViewModel)
        }
    }
}

// MARK: - Profile Tab
struct ProfileTab: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    if let user = authViewModel.currentUser {
                        // Profile Header Card
                        ProfileHeaderCard(user: user)
                            .padding(.horizontal)
                        
                        // Stats Grid
                        StatsGrid(user: user)
                            .padding(.horizontal)
                        
                        // Premium Status
                        if user.isLifetimePremium {
                            PremiumBadge()
                                .padding(.horizontal)
                        }
                        
                        // Recent Activity
                        RecentActivityCard(user: user)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Profile Components
struct ProfileHeaderCard: View {
    let user: UserViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            // Avatar
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
                .overlay(
                    Text(user.displayName.prefix(1).uppercased())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(user.displayName)
                    .font(.title2)
                    .fontWeight(.bold)
                
                if let username = user.username {
                    Text("@\(username)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(user.levelText)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(12)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20, corners: .allCorners)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

struct StatsGrid: View {
    let user: UserViewModel
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 15) {
            StatCard(
                title: "Total XP",
                value: "\(user.totalXp)",
                icon: "bolt.fill",
                color: .purple
            )
            
            StatCard(
                title: "Level",
                value: "\(user.level)",
                icon: "star.fill",
                color: .yellow
            )
            
            StatCard(
                title: "Current Streak",
                value: user.currentStreakText,
                icon: "flame.fill",
                color: .orange
            )
            
            StatCard(
                title: "Best Streak",
                value: user.longestStreakText,
                icon: "trophy.fill",
                color: .blue
            )
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15, corners: .allCorners)
    }
}

struct PremiumBadge: View {
    var body: some View {
        HStack {
            Image(systemName: "crown.fill")
                .font(.title2)
                .foregroundColor(.yellow)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Lifetime Premium")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("Enjoy unlimited access to all features")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.yellow.opacity(0.1), Color.orange.opacity(0.1)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(15, corners: .allCorners)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(
                    LinearGradient(
                        colors: [Color.yellow.opacity(0.3), Color.orange.opacity(0.3)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 1
                )
        )
    }
}

struct RecentActivityCard: View {
    let user: UserViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recent Activity")
                .font(.headline)
                .fontWeight(.bold)
            
//            if let lastActivity = user.lastActivityDate {
//                HStack {
//                    Image(systemName: "clock.fill")
//                        .foregroundColor(.blue)
//                    
//                    Text("Last active: \(lastActivity)")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                }
//            }
            
            // Activity Chart Placeholder
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue.opacity(0.1))
                .frame(height: 100)
                .overlay(
                    Text("Activity Chart")
                        .foregroundColor(.blue.opacity(0.5))
                )
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15, corners: .allCorners)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Stats Tab
struct StatsTab: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if let user = authViewModel.currentUser {
                        // Overall Progress
                        ProgressCard(user: user)
                            .padding(.horizontal)
                        
                        // Achievements
                        AchievementsSection()
                            .padding(.horizontal)
                        
                        // Leaderboard Preview
                        LeaderboardPreview()
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Statistics")
        }
    }
}

struct ProgressCard: View {
    let user: UserViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Your Progress")
                .font(.headline)
                .fontWeight(.bold)
            
            // XP Progress Bar
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("XP to Next Level")
                        .font(.subheadline)
                    Spacer()
                    Text("\(user.totalXp) / \((user.level + 1) * 1000)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 10)
                        
                        RoundedRectangle(cornerRadius: 5)
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width: min(
                                    CGFloat(user.totalXp % 1000) / 1000 * geometry.size.width,
                                    geometry.size.width
                                ),
                                height: 10
                            )
                    }
                }
                .frame(height: 10)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15, corners: .allCorners)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

struct AchievementsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recent Achievements")
                .font(.headline)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(0..<5) { _ in
                        AchievementBadge()
                    }
                }
            }
        }
    }
}

struct AchievementBadge: View {
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "star.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                )
            
            Text("Achievement")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

struct LeaderboardPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Leaderboard")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("View All") {
                    // Navigate to full leaderboard
                }
                .font(.footnote)
                .foregroundColor(.blue)
            }
            
            VStack(spacing: 10) {
                ForEach(1...3, id: \.self) { rank in
                    LeaderboardRow(rank: rank)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15, corners: .allCorners)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

struct LeaderboardRow: View {
    let rank: Int
    
    var body: some View {
        HStack(spacing: 15) {
            Text("#\(rank)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(rank == 1 ? .yellow : .primary)
            
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 35, height: 35)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Player \(rank)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("\(1000 * (4 - rank)) XP")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if rank == 1 {
                Image(systemName: "crown.fill")
                    .foregroundColor(.yellow)
            }
        }
        .padding(.vertical, 5)
    }
}

// MARK: - Settings Tab
struct SettingsTab: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSignOutAlert = false
    
    var body: some View {
        NavigationView {
            List {
                // Account Section
                Section {
                    NavigationLink(destination: AccountDetailsView()) {
                        SettingsRow(
                            icon: "person.circle.fill",
                            title: "Account Details",
                            color: .blue
                        )
                    }
                    
                    NavigationLink(destination: Text("Subscription")) {
                        SettingsRow(
                            icon: "creditcard.fill",
                            title: "Subscription",
                            color: .green
                        )
                    }
                } header: {
                    Text("Account")
                }
                
                // Preferences Section
                Section {
                    NavigationLink(destination: Text("Notifications")) {
                        SettingsRow(
                            icon: "bell.fill",
                            title: "Notifications",
                            color: .orange
                        )
                    }
                    
                    NavigationLink(destination: Text("Privacy")) {
                        SettingsRow(
                            icon: "lock.fill",
                            title: "Privacy",
                            color: .purple
                        )
                    }
                } header: {
                    Text("Preferences")
                }
                
                // Support Section
                Section {
                    NavigationLink(destination: Text("Help Center")) {
                        SettingsRow(
                            icon: "questionmark.circle.fill",
                            title: "Help Center",
                            color: .blue
                        )
                    }
                    
                    NavigationLink(destination: Text("About")) {
                        SettingsRow(
                            icon: "info.circle.fill",
                            title: "About",
                            color: .gray
                        )
                    }
                } header: {
                    Text("Support")
                }
                
                // Sign Out Section
                Section {
                    Button(action: {
                        showSignOutAlert = true
                    }) {
                        SettingsRow(
                            icon: "arrow.backward.square.fill",
                            title: "Sign Out",
                            color: .red,
                            showChevron: false
                        )
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Sign Out", isPresented: $showSignOutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    Task {
                        await authViewModel.signOut()
                    }
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    var showChevron: Bool = true
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(color)
                .cornerRadius(7)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

struct AccountDetailsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        List {
            if let user = authViewModel.currentUser {
                Section("Profile Information") {
                    DetailRow(label: "Username", value: user.username ?? "Not set")
                    DetailRow(label: "Full Name", value: user.fullName ?? "Not set")
                    DetailRow(label: "User ID", value: String(user.id.prefix(8)) + "...")
                }
                
                Section("Statistics") {
                    DetailRow(label: "Level", value: "\(user.level)")
                    DetailRow(label: "Total XP", value: "\(user.totalXp)")
                    DetailRow(label: "Current Streak", value: user.currentStreakText)
                    DetailRow(label: "Best Streak", value: user.longestStreakText)
                }
                
                if user.isLifetimePremium {
                    Section("Subscription") {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundColor(.yellow)
                            Text("Lifetime Premium Member")
                                .fontWeight(.medium)
                        }
                    }
                }
            }
        }
        .navigationTitle("Account Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}
