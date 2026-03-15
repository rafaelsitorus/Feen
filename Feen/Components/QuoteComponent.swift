import SwiftUI

struct QuoteComponent: View {
    
    let quoteMessage: String
    let isLoading: Bool
    let onRefresh: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            
            Text("\"\(quoteMessage)\"")
                .font(.caption)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: onRefresh) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
                    .rotationEffect(.degrees(isLoading ? 360 : 0))
                    .animation(
                        isLoading
                            ? .linear(duration: 1).repeatForever(autoreverses: false)
                            : .default,
                        value: isLoading
                    )
            }
            .disabled(isLoading)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 36)
                .fill(.white)
        )
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 0)
    }
}

#Preview {
    QuoteComponent(
        quoteMessage: "Lorem ipsum dolor sit amet consectetur adipiscing elit.",
        isLoading: false,
        onRefresh: {}
    )
    .padding()
}
