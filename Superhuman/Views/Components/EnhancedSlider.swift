import SwiftUI

struct EnhancedSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let onEditingChanged: (Double) -> Void
    
    @State private var isDragging = false
    @State private var localValue: Double
    @State private var lastValue: Double
    
    // For live feedback animation
    @State private var feedbackScale: CGFloat = 1.0
    
    init(value: Binding<Double>, range: ClosedRange<Double>, onEditingChanged: @escaping (Double) -> Void) {
        self._value = value
        self.range = range
        self.onEditingChanged = onEditingChanged
        self._localValue = State(initialValue: value.wrappedValue)
        self._lastValue = State(initialValue: value.wrappedValue)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                trackView(geometry)
                
                // Fill
                fillView(geometry)
                
                // Thumb
                thumbView(geometry)
            }
            .frame(height: 44) // Increased touch target per HIG
            .contentShape(Rectangle())
            .gesture(dragGesture(geometry))
            .gesture(tapGesture(geometry))
            .onChange(of: value) { _, newValue in
                localValue = newValue
            }
        }
    }
    
    private func trackView(_ geometry: GeometryProxy) -> some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color.secondary.opacity(0.25))
            .frame(height: 6)
    }
    
    private func fillView(_ geometry: GeometryProxy) -> some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(
                LinearGradient(
                    colors: [
                        Color(hex: "4158D0"),
                        Color(hex: "C850C0"),
                        Color(hex: "FFCC70")
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: fillWidth(geometry), height: 6)
    }
    
    private func thumbView(_ geometry: GeometryProxy) -> some View {
        Circle()
            .fill(.white)
            .frame(width: isDragging ? 28 : 24, height: isDragging ? 28 : 24)
            .shadow(
                color: .black.opacity(isDragging ? 0.2 : 0.15),
                radius: isDragging ? 8 : 4,
                x: 0,
                y: isDragging ? 4 : 2
            )
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 2)
                    .scaleEffect(feedbackScale)
            )
            .offset(x: thumbOffset(geometry))
            .scaleEffect(isDragging ? 1.1 : 1.0)
            .animation(.interpolatingSpring(duration: 0.3), value: isDragging)
    }
    
    private func fillWidth(_ geometry: GeometryProxy) -> CGFloat {
        let percent = (localValue - range.lowerBound) / (range.upperBound - range.lowerBound)
        return geometry.size.width * CGFloat(percent)
    }
    
    private func thumbOffset(_ geometry: GeometryProxy) -> CGFloat {
        let percent = (localValue - range.lowerBound) / (range.upperBound - range.lowerBound)
        let width = geometry.size.width
        let thumbRadius = isDragging ? 14 : 12
        return (width * CGFloat(percent)) - CGFloat(thumbRadius)
    }
    
    private func dragGesture(_ geometry: GeometryProxy) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                isDragging = true
                updateValue(geometry, at: value.location)
                provideFeedback()
            }
            .onEnded { value in
                isDragging = false
                lastValue = localValue
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    feedbackScale = 1.0
                }
            }
    }
    
    private func tapGesture(_ geometry: GeometryProxy) -> some Gesture {
        TapGesture()
            .onEnded { _ in
                provideFeedback()
            }
    }
    
    private func updateValue(_ geometry: GeometryProxy, at location: CGPoint) {
        let width = geometry.size.width
        let percent = max(0, min(1, location.x / width))
        let newValue = range.lowerBound + (range.upperBound - range.lowerBound) * Double(percent)
        localValue = newValue
        value = newValue
        onEditingChanged(newValue)
    }
    
    private func provideFeedback() {
        // Visual feedback
        withAnimation(.spring(response: 0.1, dampingFraction: 0.3)) {
            feedbackScale = 1.3
        }
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

// Preview
struct EnhancedSlider_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            // New dynamic background gradient
            LinearGradient(
                colors: [
                    Color(hex: "0F2027"),
                    Color(hex: "203A43"),
                    Color(hex: "2C5364")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            EnhancedSlider(
                value: .constant(0.5),
                range: 0...1
            ) { _ in }
            .padding()
        }
        .preferredColorScheme(.dark)
    }
} 
