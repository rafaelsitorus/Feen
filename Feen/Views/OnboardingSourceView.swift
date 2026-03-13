//
//  OnboardingSourceView.swift
//  Feen
//

import SwiftUI

import SwiftUI

struct OnboardingSourceView: View {
    @Binding var selected: SourceOfIncome?

    // Emoji per case biar lebih visual & Gen Z friendly
    func emoji(for source: SourceOfIncome) -> String {
        switch source {
        case .salary:     return "💼"
        case .freelance:  return "💻"
        case .business:   return "🏪"
        case .investment: return "📈"
        case .other:      return "✨"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            // Heading
            VStack(alignment: .leading, spacing: 12) {
                Text("🤔")
                    .font(.system(size: 48))

                Text("Where does your\nmoney come from?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                    .lineSpacing(4)

                Text("Pick the one that fits you best.")
                    .font(.system(size: 15))
                    .foregroundColor(AppTheme.textSecondary)
            }

            // Source options — grid cards
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(SourceOfIncome.allCases, id: \.self) { source in
                    sourceCard(source)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
    }

    private func sourceCard(_ source: SourceOfIncome) -> some View {
        let isSelected = selected == source

        return Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selected = source
            }
        } label: {
            VStack(spacing: 10) {
                Text(emoji(for: source))
                    .font(.system(size: 28)) // Ensures emojis are properly rendered
                    .frame(width: 50, height: 50) // Ensures enough space for the emoji

                Text(source.rawValue)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? .white : AppTheme.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                Group {
                    if isSelected {
                        AnyView(AppTheme.tealGradient)
                    } else {
                        AnyView(AppTheme.card)
                    }
                }
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.clear : AppTheme.teal.opacity(0.15), lineWidth: 1)
            )
            .shadow(color: isSelected ? AppTheme.teal.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
            .scaleEffect(isSelected ? 1.03 : 1.0)
        }
        .buttonStyle(.plain)
    }
}
