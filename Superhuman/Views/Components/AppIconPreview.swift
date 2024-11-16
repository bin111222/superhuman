import SwiftUI

struct AppIconPreview: View {
    var body: some View {
        VStack(spacing: 40) {
            // App Icon
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [
                                AppTheme.maleBlue.opacity(0.9),
                                AppTheme.femalePurple.opacity(0.9)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                
                // Superhuman Symbol
                Path { path in
                    // Male symbol (simplified)
                    path.move(to: CGPoint(x: 40, y: 50))
                    path.addLine(to: CGPoint(x: 60, y: 30))
                    path.addLine(to: CGPoint(x: 80, y: 50))
                    
                    // Female symbol (simplified)
                    path.move(to: CGPoint(x: 60, y: 70))
                    path.addEllipse(in: CGRect(x: 45, y: 55, width: 30, height: 30))
                }
                .stroke(Color.white, lineWidth: 3)
                .shadow(color: .white.opacity(0.5), radius: 5)
            }
            
            // Preview at different sizes
            HStack(spacing: 20) {
                ForEach([29, 40, 60], id: \.self) { size in
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: CGFloat(size) * 0.2)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            AppTheme.maleBlue.opacity(0.9),
                                            AppTheme.femalePurple.opacity(0.9)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: CGFloat(size), height: CGFloat(size))
                            
                            Path { path in
                                let scale = CGFloat(size) / 120
                                path.move(to: CGPoint(x: 40 * scale, y: 50 * scale))
                                path.addLine(to: CGPoint(x: 60 * scale, y: 30 * scale))
                                path.addLine(to: CGPoint(x: 80 * scale, y: 50 * scale))
                                
                                path.move(to: CGPoint(x: 60 * scale, y: 70 * scale))
                                path.addEllipse(in: CGRect(x: 45 * scale, y: 55 * scale, width: 30 * scale, height: 30 * scale))
                            }
                            .stroke(Color.white, lineWidth: 2 * (CGFloat(size) / 120))
                        }
                        
                        Text("\(size)pt")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

#Preview {
    AppIconPreview()
        .preferredColorScheme(.dark)
} 