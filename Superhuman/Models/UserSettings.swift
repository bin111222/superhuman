import SwiftUI

class UserSettings: ObservableObject {
    @Published var gender: Gender = .notSpecified
    @Published var hasCompletedOnboarding: Bool = false
    
    // User biometrics
    @Published var height: Double = 170 // cm
    @Published var weight: Double = 70 // kg
    
    // Selected goals
    @Published var selectedGoals: Set<String> = []
} 