//
//  SuperhumanApp.swift
//  Superhuman
//
//  Created by varil shah on 16/11/24.
//

import SwiftUI

@main
struct SuperhumanApp: App {
    @StateObject private var userSettings = UserSettings()
    
    var body: some Scene {
        WindowGroup {
            if userSettings.hasCompletedOnboarding {
                ContentView()
                    .environmentObject(userSettings)
            } else {
                OnboardingView()
                    .environmentObject(userSettings)
            }
        }
    }
}
