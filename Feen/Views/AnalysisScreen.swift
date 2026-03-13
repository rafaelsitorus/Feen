//
//  AnalysisScreen.swift
//  Feen
//
//  Created by Pangihutan Sitorus on 11/03/26.
//

import SwiftUI

struct AnalysisScreen: View {
    let analysis: InvoiceAnalysis
    var onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text(analysis.vendorName)
                            .font(.title2.bold())
                        Text(analysis.invoiceDate)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Divider()

                    // Line items
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Line Items")
                            .font(.headline)
                        ForEach(analysis.lineItems) { item in
                            HStack {
                                Text(item.description)
                                Spacer()
                                Text(String(format: "%.0f", item.amount))
                                    .bold()
                            }
                        }
                    }

                    Divider()

                    // Total
                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "%.0f", analysis.totalAmount))
                            .font(.title3.bold())
                    }

                    Divider()

                    // Health rating badge
                    HStack {
                        Text("Financial Health")
                            .font(.headline)
                        Spacer()
                        Text(analysis.healthRating.capitalized)
                            .bold()
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(healthColor.opacity(0.15))
                            .foregroundStyle(healthColor)
                            .clipShape(Capsule())
                    }

                    // Percentage
                    Text("This invoice is **\(String(format: "%.1f", analysis.percentageOfWage))%** of your monthly wage.")

                    // Summary
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Summary")
                            .font(.headline)
                        Text(analysis.summary)
                    }

                    // Tip
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Tip")
                            .font(.headline)
                        Text(analysis.tip)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("Invoice Analysis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { onDismiss() }
                }
            }
        }
    }

    private var healthColor: Color {
        switch analysis.healthRating.lowercased() {
        case "healthy": return .green
        case "moderate": return .orange
        default: return .red
        }
    }
}
