//
//  HistoryView.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 11/03/26.
//

import SwiftUI

struct HistoryComponents: View {
    @State private var showAllHistory: Bool = false
    
    var historyRecords: [HistoryModel]
    var isHome: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Show title + View All only if isHome == true
            if isHome {
                HStack {
                    Text("History")
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if historyRecords.count > 5 {
                        Button(action: {
                            showAllHistory = true
                        }) {
                            Text("View All")
                                .font(.footnote)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding([.top, .horizontal])
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Show only 5 items if isHome, otherwise show all
                    ForEach(historyRecords.prefix(isHome ? 5 : historyRecords.count)) { record in
                        HistoryItem(record: record)
                    }
                }
                .padding()
            }
        }
        .padding(.bottom, 72)
        .fullScreenCover(isPresented: $showAllHistory) {
            NavigationStack {
                AllHistoryScreen(historyRecords: historyRecords)
                    .navigationTitle("History")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Close") {
                                showAllHistory = false
                            }
                        }
                    }
            }
        }
    }
    
    struct HistoryItem: View {
        let record: HistoryModel
        
        var body: some View {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(
                            record.isIncome ? .green
                                .opacity(0.15) : .red
                                .opacity(0.15)
                        )
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: record.category.icon)
                        .foregroundColor(record.isIncome ? .green : .red)
                }
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(record.category.name)
                        .font(.headline)
                    
                    Text(record.description ?? "-")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    Text(record.date.formatted(
                        .dateTime.weekday(.wide).day().month(.wide).year()
                    ))
                    .lineLimit(1)
                    .font(.system(size: 8))
                    .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Amount
                Text(
                    record.amount,
                    format: .currency(code: "IDR")
                )
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(record.isIncome ? .green : .red)
                .monospacedDigit()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
            )
            .shadow(color: .black.opacity(0.08), radius: 6)
        }
    }
}

#Preview {
    let sampleHistory: [HistoryModel] = [
        HistoryModel(
            amount: 100,
            date: Date(),
            category: .defaultExpenses[1],
            description: "Lunch"
        ),
        HistoryModel(
            amount: 50,
            date: Date(),
            category: .defaultIncomes[0],
            description: "Bus fare"
        ),
        HistoryModel(
            amount: 200,
            date: Date(),
            category: .defaultExpenses[2],
            description: "Groceries"
        )
    ]
    
    HistoryComponents(historyRecords: sampleHistory, isHome: true)
}
