//
//  OnboardingIncomeView.swift
//  Feen
//

import SwiftUI

struct OnboardingIncomeView: View {
    @Binding var incomeText: String
    let name: String
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            // Emoji + heading
            VStack(alignment: .leading, spacing: 12) {
                Text("💰")
                    .font(.system(size: 48))

                Text("How much do you\nearn per month\(name.isEmpty ? "?" : ", \(name)?")")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                    .lineSpacing(4)

                Text("Your income helps us give\nbetter spending insights.")
                    .font(.system(size: 15))
                    .foregroundColor(AppTheme.textSecondary)
                    .lineSpacing(4)
            }

            // Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Monthly income")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)

                HStack(spacing: 0) {
                    Text("Rp  ")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppTheme.teal)
                        .padding(.leading, 16)

                    TextField("0", text: $incomeText)
                        .keyboardType(.numberPad)
                        .font(.system(size: 18))
                        .foregroundColor(AppTheme.textPrimary)
                        .padding(.vertical, 16)
                        .padding(.trailing, 16)
                        .focused($isFocused)
                }
                .background(AppTheme.card)
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(isFocused ? AppTheme.teal : AppTheme.teal.opacity(0.2), lineWidth: 1.5)
                )
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
        .onAppear { isFocused = true }
    }
}
