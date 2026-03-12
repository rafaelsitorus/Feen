//
//  OnboardingBudgetView.swift
//  Feen
//

import SwiftUI

struct OnboardingBudgetView: View {
    @Binding var budgetText: String
    let income: Double?
    @FocusState private var isFocused: Bool

    // Suggest 50% / 70% / 80% of income as quick-pick chips
    private var suggestions: [(label: String, value: Double)] {
        guard let income else { return [] }
        return [
            ("50%", income * 0.5),
            ("70%", income * 0.7),
            ("80%", income * 0.8)
        ]
    }

    private func formatted(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            // Heading
            VStack(alignment: .leading, spacing: 12) {
                Text("🎯")
                    .font(.system(size: 48))

                Text("Set your spending\nlimit this month.")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                    .lineSpacing(4)

                Text("This helps you stay on track\nand avoid overspending.")
                    .font(.system(size: 15))
                    .foregroundColor(AppTheme.textSecondary)
                    .lineSpacing(4)
            }

            VStack(alignment: .leading, spacing: 16) {
                // Input field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Monthly budget")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(AppTheme.textSecondary)

                    HStack(spacing: 0) {
                        Text("Rp  ")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(AppTheme.teal)
                            .padding(.leading, 16)

                        TextField("0", text: $budgetText)
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

                // Quick-pick chips (hanya muncul kalau income sudah diisi)
                if !suggestions.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Quick pick")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(AppTheme.textSecondary)

                        HStack(spacing: 10) {
                            ForEach(suggestions, id: \.label) { suggestion in
                                Button {
                                    budgetText = formatted(suggestion.value)
                                    isFocused = false
                                } label: {
                                    VStack(spacing: 2) {
                                        Text(suggestion.label)
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(AppTheme.teal)
                                        Text("Rp\(formatted(suggestion.value))")
                                            .font(.system(size: 11))
                                            .foregroundColor(AppTheme.textSecondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(AppTheme.teal.opacity(0.08))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(AppTheme.teal.opacity(0.25), lineWidth: 1)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
        .onAppear { isFocused = true }
    }
}
