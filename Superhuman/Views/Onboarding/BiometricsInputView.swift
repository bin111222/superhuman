import SwiftUI

struct BiometricsInputView: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var onboardingState: OnboardingState
    @State private var isAnimating = false
    @State private var isMetric = true
    @State private var heightFeet = 5
    @State private var heightInches = 8
    @State private var localHeight: Double = 170 // cm
    @State private var localWeight: Double = 70 // kg
    
    private let heightRange: ClosedRange<Double> = 120...220 // cm
    private let weightRange: ClosedRange<Double> = 30...200 // kg
    
    var body: some View {
        ZStack {
            NoiseGradient(colors: [
                Color(hex: "0F2027"),
                Color(hex: "203A43"),
                Color(hex: "2C5364")
            ])
            
            VStack(spacing: 0) {
                titleSection
                    .padding(.top, 60)
                    .padding(.bottom, 40)
                
                measurementToggle
                    .padding(.bottom, 50)
                
                measurementsSection
                
                Spacer()
                
                pageIndicator
                    .padding(.bottom, 30)
            }
            .padding(.horizontal)
        }
        .onAppear { startAnimation() }
    }
    
    private var titleSection: some View {
        VStack(spacing: 8) {
            Text("Your Measurements")
                .font(.system(.title, design: .rounded, weight: .bold))
                .multilineTextAlignment(.center)
            
            Text("Help us personalize your fitness journey")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .opacity(isAnimating ? 1 : 0)
        .offset(y: isAnimating ? 0 : 20)
        .animation(.spring(duration: 0.7, bounce: 0.4).delay(0.1), value: isAnimating)
    }
    
    private var measurementToggle: some View {
        Picker("Unit System", selection: $isMetric) {
            Text("Metric").tag(true)
            Text("Imperial").tag(false)
        }
        .pickerStyle(.segmented)
        .frame(width: 200)
        .opacity(isAnimating ? 1 : 0)
        .onChange(of: isMetric) { _, _ in
            updateMeasurements()
        }
    }
    
    private var measurementsSection: some View {
        VStack(spacing: 40) {
            // Height
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "ruler.fill")
                        .foregroundColor(.secondary)
                    Text("Height")
                        .foregroundColor(.secondary)
                }
                
                if isMetric {
                    heightSliderMetric
                } else {
                    heightSliderImperial
                }
            }
            
            // Weight
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "scalemass.fill")
                        .foregroundColor(.secondary)
                    Text("Weight")
                        .foregroundColor(.secondary)
                }
                
                if isMetric {
                    weightSliderMetric
                } else {
                    weightSliderImperial
                }
            }
        }
        .opacity(isAnimating ? 1 : 0)
        .offset(y: isAnimating ? 0 : 30)
        .animation(.spring(duration: 0.7, bounce: 0.4).delay(0.2), value: isAnimating)
    }
    
    private var heightSliderMetric: some View {
        VStack(spacing: 8) {
            Text("\(Int(localHeight)) cm")
                .font(.system(.title, design: .rounded, weight: .bold))
                .foregroundColor(.white)
            
            EnhancedSlider(value: $localHeight, range: heightRange) { value in
                userSettings.height = value
            }
        }
    }
    
    private var heightSliderImperial: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Picker("Feet", selection: $heightFeet) {
                    ForEach(2...7, id: \.self) { feet in
                        Text("\(feet) ft").tag(feet)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
                
                Picker("Inches", selection: $heightInches) {
                    ForEach(0...11, id: \.self) { inches in
                        Text("\(inches) in").tag(inches)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
            }
            .onChange(of: heightFeet) { _, _ in updateHeightFromImperial() }
            .onChange(of: heightInches) { _, _ in updateHeightFromImperial() }
        }
    }
    
    private var weightSliderMetric: some View {
        VStack(spacing: 8) {
            Text("\(Int(localWeight)) kg")
                .font(.system(.title, design: .rounded, weight: .bold))
                .foregroundColor(.white)
            
            EnhancedSlider(value: $localWeight, range: weightRange) { value in
                userSettings.weight = value
            }
        }
    }
    
    private var weightSliderImperial: some View {
        VStack(spacing: 8) {
            Text("\(Int(localWeight * 2.20462)) lbs")
                .font(.system(.title, design: .rounded, weight: .bold))
                .foregroundColor(.white)
            
            EnhancedSlider(value: $localWeight, range: weightRange) { value in
                userSettings.weight = value
            }
        }
    }
    
    private var pageIndicator: some View {
        PageIndicator(currentPage: 1, totalPages: 4)
            .opacity(isAnimating ? 1 : 0)
    }
    
    private func startAnimation() {
        withAnimation {
            isAnimating = true
        }
    }
    
    private func updateMeasurements() {
        if isMetric {
            // Convert feet to centimeters
            let feetToCm = Double(heightFeet) * 30.48
            // Convert inches to centimeters
            let inchesToCm = Double(heightInches) * 2.54
            // Sum up the total height
            localHeight = feetToCm + inchesToCm
            // Update user settings
            userSettings.height = localHeight
        } else {
            // Convert total inches to centimeters
            let totalInches = Double(heightFeet * 12 + heightInches)
            localHeight = totalInches * 2.54
            // Update user settings
            userSettings.height = localHeight
        }
    }
    
    private func updateHeightFromImperial() {
        // Convert feet to centimeters
        let feetToCm = Double(heightFeet) * 30.48
        // Convert inches to centimeters
        let inchesToCm = Double(heightInches) * 2.54
        // Update local and user settings height
        localHeight = feetToCm + inchesToCm
        userSettings.height = localHeight
    }
    
    private func proceedToNext() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        withAnimation {
            onboardingState.nextPage()
        }
    }
}

struct BiometricsInputView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Male version
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
                
                BiometricsInputView()
            }
            .environmentObject({
                let settings = UserSettings()
                settings.gender = .male
                return settings
            }())
            .environmentObject(OnboardingState())
            .previewDisplayName("Male User")
            
            // Female version
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
                
                BiometricsInputView()
            }
            .environmentObject({
                let settings = UserSettings()
                settings.gender = .female
                return settings
            }())
            .environmentObject(OnboardingState())
            .previewDisplayName("Female User")
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    BiometricsInputView()
        .environmentObject(UserSettings())
        .environmentObject(OnboardingState())
} 