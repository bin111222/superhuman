import SwiftUI

struct GoalsSelectionView: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var onboardingState: OnboardingState
    @State private var isAnimating = false
    
    // Placeholder goals - you can expand this based on the roadmap
    let availableGoals = [
        "Strength Building",
        "Weight Management",
        "Endurance Training",
        "Flexibility & Mobility",
        "Mental Wellness",
        "Performance Enhancement",
        "Recovery & Injury Prevention",
        "Nutritional Balance"
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Your Goals")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 20)
            
            Text("Select all that apply")
                .font(.system(.title3, design: .rounded))
                .foregroundColor(.secondary)
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 20)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                    ForEach(availableGoals, id: \.self) { goal in
                        GoalCard(
                            goal: goal,
                            isSelected: userSettings.selectedGoals.contains(goal)
                        ) {
                            toggleGoal(goal)
                        }
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : 50)
                    }
                }
                .padding()
            }
            
            Button(action: proceedToNext) {
                Text("Continue")
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 200)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(userSettings.gender == .male ? AppTheme.maleBlue : AppTheme.femalePurple)
                    )
            }
            .opacity(isAnimating ? 1 : 0)
            .offset(y: isAnimating ? 0 : 20)
        }
        .padding()
        .onAppear { startAnimation() }
    }
    
    private func startAnimation() {
        withAnimation {
            isAnimating = true
        }
    }
    
    private func toggleGoal(_ goal: String) {
        withAnimation(.spring(duration: 0.3)) {
            if userSettings.selectedGoals.contains(goal) {
                userSettings.selectedGoals.remove(goal)
            } else {
                userSettings.selectedGoals.insert(goal)
            }
        }
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    private func proceedToNext() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        withAnimation {
            onboardingState.nextPage()
        }
    }
}

struct GoalCard: View {
    let goal: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(goal)
                    .font(.system(.headline, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(isSelected ? .white : .primary)
                    .padding()
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(isSelected ? 
                                  AppTheme.teal.opacity(0.8) : 
                                  Color.secondary.opacity(0.1))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(isSelected ? AppTheme.teal : Color.clear, 
                                   lineWidth: 2)
                    )
            }
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(duration: 0.2), value: isSelected)
    }
}

#Preview {
    GoalsSelectionView()
        .environmentObject(UserSettings())
        .environmentObject(OnboardingState())
} 