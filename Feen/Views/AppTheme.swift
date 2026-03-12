import SwiftUI

enum AppTheme {
    // MARK: - Colors
    static let teal         = Color(red: 0.0,  green: 0.55, blue: 0.50)
    static let darkTeal     = Color(red: 0.0,  green: 0.33, blue: 0.30)
    static let background   = Color(red: 0.96, green: 0.97, blue: 0.98)
    static let card         = Color.white
    static let textPrimary  = Color(red: 0.1,  green: 0.1,  blue: 0.1)
    static let textSecondary = Color(red: 0.5, green: 0.5,  blue: 0.55)

    // MARK: - Gradients
    static let tealGradient = LinearGradient(
        colors: [darkTeal, teal],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let tealGradientHorizontal = LinearGradient(
        colors: [teal, darkTeal],
        startPoint: .leading,
        endPoint: .trailing
    )
}
