//
//  ContentView.swift
//  Superhuman
//
//  Created by varil shah on 16/11/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        Group {
            if !userSettings.hasCompletedOnboarding {
                OnboardingView()
            } else {
                MainTabView()
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct MainTabView: View {
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
            
            WorkoutView()
                .tabItem {
                    Label("Workout", systemImage: "figure.run")
                }
            
            NutritionView()
                .tabItem {
                    Label("Nutrition", systemImage: "leaf.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .tint(userSettings.gender == .male ? AppTheme.maleBlue : AppTheme.femalePurple)
    }
}

// Placeholder views for main app sections
struct DashboardView: View {
    var body: some View {
        Text("Dashboard Coming Soon")
    }
}

struct WorkoutView: View {
    var body: some View {
        Text("Workout Coming Soon")
    }
}

struct NutritionView: View {
    var body: some View {
        Text("Nutrition Coming Soon")
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile Coming Soon")
    }
}

#Preview("Onboarding Flow") {
    ContentView()
        .environmentObject({
            let settings = UserSettings()
            settings.hasCompletedOnboarding = false
            return settings
        }())
}

#Preview("Main App - Male") {
    ContentView()
        .environmentObject({
            let settings = UserSettings()
            settings.hasCompletedOnboarding = true
            settings.gender = .male
            return settings
        }())
}

#Preview("Main App - Female") {
    ContentView()
        .environmentObject({
            let settings = UserSettings()
            settings.hasCompletedOnboarding = true
            settings.gender = .female
            return settings
        }())
}
