//
//  ExpenseSummaryView.swift
//  Feen
//

import SwiftUI

struct ExpenseSummaryView: View {
    let amount: Int
    let category: Category
    let expenseDescription: String
    let monthlyIncome: Double
    let totalSpent: Int
    var onDismiss: () -> Void

    @State private var summary: String?
    @State private var isLoading = true
    @State private var errorMessage: String?

    private let tealGradient = LinearGradient(
        colors: [Color(red: 0.0, green: 0.55, blue: 0.50),
                 Color(red: 0.0, green: 0.33, blue: 0.30)],
        startPoint: .leading, endPoint: .trailing)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Amount card
                    VStack(spacing: 8) {
                        Text("Expense Saved")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("Rp \(formattedAmount)")
                            .font(.largeTitle.bold())
                        HStack(spacing: 6) {
                            Image(systemName: category.icon)
                            Text(category.name)
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                    )

                    if !expenseDescription.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Description")
                                .font(.caption).foregroundStyle(.secondary)
                            Text(expenseDescription)
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Divider()

                    // AI Summary
                    VStack(alignment: .leading, spacing: 8) {
                        Text("AI Summary")
                            .font(.headline)

                        if isLoading {
                            HStack(spacing: 10) {
                                ProgressView()
                                Text("Analyzing your expense...")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                        } else if let summary = summary {
                            Text(summary)
                                .font(.subheadline)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.systemGray6))
                                )
                        } else if let error = errorMessage {
                            Text(error)
                                .font(.subheadline)
                                .foregroundStyle(.red)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.red.opacity(0.1))
                                )
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Done button
                    Button(action: onDismiss) {
                        Text("Done")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(tealGradient)
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Expense Summary")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await loadSummary()
        }
    }

    private var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }

    private func loadSummary() async {
        do {
            let result = try await GeminiService.shared.summarizeExpense(
                amount: amount,
                category: category.name,
                description: expenseDescription,
                monthlyIncome: monthlyIncome,
                totalSpent: totalSpent
            )
            summary = result
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
