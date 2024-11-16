import SwiftUI

struct NoiseGradient: View {
    let colors: [Color]
    @State private var phase: CGFloat = 0
    
    init(colors: [Color] = [
        Color(hex: "0F2027"),
        Color(hex: "203A43"),
        Color(hex: "2C5364")
    ]) {
        self.colors = colors
    }
    
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Animated noise overlay
            GeometryReader { geometry in
                Canvas { context, size in
                    // Create noise pattern
                    context.drawLayer { ctx in
                        // Generate multiple overlapping noise layers
                        for i in 0...10 {
                            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                            ctx.opacity = 0.5
                            
                            // Create dynamic pattern with varying sizes for blur-like effect
                            for x in stride(from: 0, to: size.width, by: 4) {
                                for y in stride(from: 0, to: size.height, by: 4) {
                                    let randomValue = Double.random(in: 0...1)
                                    if randomValue > 0.95 {
                                        let dotSize = CGFloat(i) * 0.5 + 1
                                        let point = Path(ellipseIn: CGRect(
                                            x: x,
                                            y: y,
                                            width: dotSize,
                                            height: dotSize
                                        ))
                                        ctx.fill(
                                            point,
                                            with: .color(.white.opacity(0.1 / CGFloat(i + 1)))
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
                .opacity(0.15)
                .blendMode(.overlay)
                .animation(.linear(duration: 20).repeatForever(autoreverses: true), value: phase)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: true)) {
                phase = 1
            }
        }
    }
}

#Preview {
    NoiseGradient()
        .preferredColorScheme(.dark)
} 