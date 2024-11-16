import SwiftUI
import AuthenticationServices

struct AuthenticationView: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var onboardingState: OnboardingState
    @State private var isAnimating = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 30) {
            titleSection
            
            authButtons
            
            skipButton
        }
        .padding()
        .onAppear { startAnimation() }
        .alert("Authentication Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private var titleSection: some View {
        VStack(spacing: 16) {
            Text("Almost There!")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .multilineTextAlignment(.center)
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 20)
            
            Text("Sign in to save your progress")
                .font(.system(.title3, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 20)
        }
        .animation(.spring(duration: 0.7, bounce: 0.4).delay(0.1), value: isAnimating)
    }
    
    private var authButtons: some View {
        VStack(spacing: 20) {
            // Apple Sign In Button
            SignInWithAppleButton { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                handleSignInWithAppleResult(result)
            }
            .signInWithAppleButtonStyle(.white)
            .frame(height: 50)
            .cornerRadius(8)
            
            // Email Sign In Button
            Button(action: showEmailSignIn) {
                HStack {
                    Image(systemName: "envelope.fill")
                    Text("Continue with Email")
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.secondary.opacity(0.2))
                .foregroundColor(.primary)
                .cornerRadius(8)
            }
        }
        .frame(maxWidth: 280)
        .opacity(isAnimating ? 1 : 0)
        .offset(y: isAnimating ? 0 : 30)
        .animation(.spring(duration: 0.7, bounce: 0.4).delay(0.2), value: isAnimating)
    }
    
    private var skipButton: some View {
        Button(action: skipAuthentication) {
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
    
    private func handleSignInWithAppleResult(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                // Handle successful sign in
                print("Successfully signed in with Apple ID: \(appleIDCredential.user)")
                completeOnboarding()
            }
        case .failure(let error):
            showError = true
            errorMessage = error.localizedDescription
        }
    }
    
    private func showEmailSignIn() {
        // Implement email sign in flow
        // For now, just show a placeholder message
        showError = true
        errorMessage = "Email sign in will be implemented in a future update"
    }
    
    private func skipAuthentication() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        completeOnboarding()
    }
    
    private func completeOnboarding() {
        withAnimation {
            userSettings.hasCompletedOnboarding = true
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
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
            
            AuthenticationView()
        }
        .environmentObject(UserSettings())
        .environmentObject(OnboardingState())
        .preferredColorScheme(.dark)
    }
} 