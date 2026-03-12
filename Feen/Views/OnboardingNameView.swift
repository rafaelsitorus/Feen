//
//  OnboardingNameView.swift
//  Feen
//

import SwiftUI

struct OnboardingNameView: View {
    @Binding var name: String
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            // Emoji + heading
            VStack(alignment: .leading, spacing: 12) {
                Text(verbatim: "👋")
                    .font(.system(size: 48))

                Text("What's your name?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)

                Text("We'll use this to personalize\nyour experience.")
                    .font(.system(size: 15))
                    .foregroundColor(AppTheme.textSecondary)
                    .lineSpacing(4)
            }

            // Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Your name")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)

                TextField("e.g. Christian", text: $name)
                    .font(.system(size: 18))
                    .foregroundColor(AppTheme.textPrimary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background(AppTheme.card)
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(isFocused ? AppTheme.teal : AppTheme.teal.opacity(0.2), lineWidth: 1.5)
                    )
                    .focused($isFocused)
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
        .onAppear { isFocused = true }
    }
}
