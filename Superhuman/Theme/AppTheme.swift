import SwiftUI

enum Gender {
    case male
    case female
    case notSpecified
}

struct AppTheme {
    // Primary Colors
    static let maleBlue = Color(hex: "1E3D59")
    static let maleGray = Color(hex: "434371")
    static let maleGold = Color(hex: "FFD700")
    
    static let femalePurple = Color(hex: "663399")
    static let femaleRose = Color(hex: "FF69B4")
    static let femaleSilver = Color(hex: "C0C0C0")
    
    // Shared Colors
    static let teal = Color(hex: "008080")
    static let white = Color(hex: "FFFFFF")
    static let charcoal = Color(hex: "36454F")
}

// Color hex extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 