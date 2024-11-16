import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var userSettings: UserSettings
    @StateObject private var onboardingState = OnboardingState()
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    AppTheme.maleBlue.opacity(0.6),
                    AppTheme.femalePurple.opacity(0.6)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            TabView(selection: $onboardingState.currentPage) {
                GenderSelectionView()
                    .environmentObject(onboardingState)
                    .tag(0)
                BiometricsInputView()
                    .environmentObject(onboardingState)
                    .tag(1)
                GoalsSelectionView()
                    .environmentObject(onboardingState)
                    .tag(2)
                AuthenticationView()
                    .environmentObject(onboardingState)
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: onboardingState.currentPage)
            .gesture(DragGesture().onEnded { _ in }) // Disable swipe navigation
            
            // Custom page indicator
            VStack {
                Spacer()
                PageIndicator(currentPage: onboardingState.currentPage, totalPages: 4)
                    .padding(.bottom, 20)
            }
        }
    }
}

struct PageIndicator: View {
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(currentPage == index ? .white : .white.opacity(0.5))
                    .frame(width: 8, height: 8)
                    .scaleEffect(currentPage == index ? 1.2 : 1.0)
                    .animation(.spring(duration: 0.2), value: currentPage)
            }
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(UserSettings())
} 