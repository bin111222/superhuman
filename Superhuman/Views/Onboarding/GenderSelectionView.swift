import SwiftUI

struct GenderSelectionView: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var onboardingState: OnboardingState
    @State private var selectedGender: Gender? = nil
    @State private var isAnimating = false
    
    private let cardSpacing: CGFloat = 20
    
    var body: some View {
        VStack(spacing: 30) {
            titleSection
            
            cardsSection
            
            skipButton
        }
        .padding()
        .onAppear { startAnimation() }
    }
    
    private var titleSection: some View {
        VStack(spacing: 16) {
            Text("Welcome to Superhuman")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .multilineTextAlignment(.center)
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 20)
            
            Text("Let's personalize your experience")
                .font(.system(.title3, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 20)
        }
        .animation(.spring(duration: 0.7, bounce: 0.4).delay(0.1), value: isAnimating)
    }
    
    private var cardsSection: some View {
        HStack(spacing: cardSpacing) {
            GenderCard(
                gender: .male,
                isSelected: selectedGender == .male,
                color: AppTheme.maleBlue,
                iconName: "figure.arms.open",
                title: "Male"
            )
            .onTapGesture { selectGender(.male) }
            
            GenderCard(
                gender: .female,
                isSelected: selectedGender == .female,
                color: AppTheme.femalePurple,
                iconName: "figure.dress.line.vertical.figure",
                title: "Female"
            )
            .onTapGesture { selectGender(.female) }
        }
        .opacity(isAnimating ? 1 : 0)
        .offset(y: isAnimating ? 0 : 50)
        .animation(.spring(duration: 0.7, bounce: 0.4).delay(0.2), value: isAnimating)
    }
    
    private var skipButton: some View {
        Button(action: skipSelection) {
            Text("Skip for now")
                .font(.system(.body, design: .rounded))
                .foregroundColor(.secondary)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                )
        }
        .opacity(isAnimating ? 1 : 0)
        .offset(y: isAnimating ? 0 : 20)
        .animation(.spring(duration: 0.7, bounce: 0.4).delay(0.3), value: isAnimating)
    }
    
    private func startAnimation() {
        withAnimation {
            isAnimating = true
        }
    }
    
    private func selectGender(_ gender: Gender) {
        withAnimation(.spring(duration: 0.4)) {
            selectedGender = gender
            userSettings.gender = gender
        }
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Proceed to next screen after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                onboardingState.nextPage()
            }
        }
    }
    
    private func skipSelection() {
        withAnimation {
            userSettings.gender = .notSpecified
            onboardingState.nextPage()
        }
    }
}

struct GenderCard: View {
    let gender: Gender
    let isSelected: Bool
    let color: Color
    let iconName: String
    let title: String
    
    @State private var isHovered = false
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .font(.system(size: 60))
                .foregroundColor(color)
                .padding(.bottom, 10)
                .scaleEffect(isSelected ? 1.1 : 1.0)
            
            Text(title)
                .font(.system(.title2, design: .rounded, weight: .semibold))
                .foregroundColor(color)
        }
        .frame(width: 150, height: 200)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: color.opacity(0.3), radius: isSelected ? 15 : 10, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isSelected ? color : .clear, lineWidth: 3)
        )
        .scaleEffect(isSelected ? 1.05 : (isHovered ? 1.02 : 1.0))
        .animation(.spring(duration: 0.3), value: isSelected)
        .animation(.spring(duration: 0.3), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(
            gradient: Gradient(colors: [
                AppTheme.maleBlue.opacity(0.6),
                AppTheme.femalePurple.opacity(0.6)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        GenderSelectionView()
    }
    .environmentObject(UserSettings())
    .environmentObject(OnboardingState())
    .preferredColorScheme(.dark)
} 