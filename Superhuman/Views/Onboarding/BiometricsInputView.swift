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
        VStack(spacing: 30) {
            titleSection
            
            measurementToggle
            
            biometricsSection
            
            nextButton
        }
        .padding()
        .onAppear { startAnimation() }
    }
    
    private var titleSection: some View {
        VStack(spacing: 16) {
            Text("Your Measurements")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .multilineTextAlignment(.center)
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 20)
            
            Text("Help us personalize your fitness journey")
                .font(.system(.title3, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 20)
        }
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
        .animation(.spring(duration: 0.7, bounce: 0.4).delay(0.2), value: isAnimating)
        .onChange(of: isMetric) { _, newValue in
            updateMeasurements()
        }
    }
    
    private var biometricsSection: some View {
        VStack(spacing: 40) {
            // Height Selector
            VStack(spacing: 20) {
                HStack {
                    Image(systemName: "ruler.fill")
                        .font(.title2)
                    Text("Height")
                        .font(.title3.bold())
                }
                
                if isMetric {
                    heightSliderMetric
                } else {
                    heightSliderImperial
                }
            }
            
            // Weight Selector
            VStack(spacing: 20) {
                HStack {
                    Image(systemName: "scalemass.fill")
                        .font(.title2)
                    Text("Weight")
                        .font(.title3.bold())
                }
                
                if isMetric {
                    weightSliderMetric
                } else {
                    weightSliderImperial
                }
            }
        }
        .opacity(isAnimating ? 1 : 0)
        .offset(y: isAnimating ? 0 : 50)
        .animation(.spring(duration: 0.7, bounce: 0.4).delay(0.3), value: isAnimating)
    }
    
    private var heightSliderMetric: some View {
        VStack {
            Text("\(Int(localHeight)) cm")
                .font(.system(.title, design: .rounded, weight: .bold))
                .foregroundColor(userSettings.gender == .male ? AppTheme.maleBlue : AppTheme.femalePurple)
            
            CustomSlider(value: $localHeight, range: heightRange) { value in
                userSettings.height = value
            }
        }
    }
    
    private var heightSliderImperial: some View {
        VStack {
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
            .onChange(of: heightFeet) { _, newValue in 
                updateHeightFromImperial()
            }
            .onChange(of: heightInches) { _, newValue in 
                updateHeightFromImperial()
            }
        }
    }
    
    private var weightSliderMetric: some View {
        VStack {
            Text("\(Int(localWeight)) kg")
                .font(.system(.title, design: .rounded, weight: .bold))
                .foregroundColor(userSettings.gender == .male ? AppTheme.maleBlue : AppTheme.femalePurple)
            
            CustomSlider(value: $localWeight, range: weightRange) { value in
                userSettings.weight = value
            }
        }
    }
    
    private var weightSliderImperial: some View {
        VStack {
            Text("\(Int(localWeight * 2.20462)) lbs")
                .font(.system(.title, design: .rounded, weight: .bold))
                .foregroundColor(userSettings.gender == .male ? AppTheme.maleBlue : AppTheme.femalePurple)
            
            CustomSlider(value: $localWeight, range: weightRange) { value in
                userSettings.weight = value
            }
        }
    }
    
    private var nextButton: some View {
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
        .animation(.spring(duration: 0.7, bounce: 0.4).delay(0.4), value: isAnimating)
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

struct CustomSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let onEditingChanged: (Double) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.secondary.opacity(0.2))
                    .frame(height: 6)
                    .cornerRadius(3)
                
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [AppTheme.teal, AppTheme.maleBlue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(width: self.getProgressWidth(geometry: geometry), height: 6)
                    .cornerRadius(3)
                
                Circle()
                    .fill(.white)
                    .frame(width: 24, height: 24)
                    .shadow(radius: 4)
                    .offset(x: self.getThumbOffset(geometry: geometry))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                self.updateValue(geometry: geometry, location: gesture.location)
                            }
                    )
            }
        }
        .frame(height: 24)
    }
    
    private func getProgressWidth(geometry: GeometryProxy) -> CGFloat {
        let percent = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return geometry.size.width * CGFloat(percent)
    }
    
    private func getThumbOffset(geometry: GeometryProxy) -> CGFloat {
        let percent = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return geometry.size.width * CGFloat(percent) - 12
    }
    
    private func updateValue(geometry: GeometryProxy, location: CGPoint) {
        let percent = max(0, min(1, location.x / geometry.size.width))
        let newValue = range.lowerBound + (range.upperBound - range.lowerBound) * Double(percent)
        value = newValue
        onEditingChanged(newValue)
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