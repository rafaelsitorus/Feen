//
//  HistoryView.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 11/03/26.
//

import SwiftUI

struct HistoryItemView: View {
    let record: HistoryModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // Left icon indicating earned/spent
            Circle()
                .fill(record.isEarned ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: record.isEarned ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                        .foregroundColor(record.isEarned ? .green : .red)
                        .font(.title2)
                )
            
            // Category and description
            VStack(alignment: .leading, spacing: 4) {
                Text(record.category)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(record.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text(record.date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Expense amount
            Text(formattedExpense)
                .font(.headline)
                .foregroundColor(record.isEarned ? .green : .red)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemGray6))
        )
        .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 0)
    }
    
    private var formattedExpense: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = Locale.current.currency?.identifier ?? "USD"
        return formatter.string(from: NSNumber(value: record.expense)) ?? "$\(record.expense)"
    }
}

struct HistoryView: View {
    let historyRecords = [
        HistoryModel(date: "11/03/25", category: "Food", description: "Lunch at cafe", expense: 10000, isEarned: false),
        HistoryModel(date: "10/03/25", category: "Salary", description: "Monthly paycheck", expense: 500000, isEarned: true),
        HistoryModel(date: "09/03/25", category: "Transport", description: "Bus pass", expense: 15000, isEarned: false)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("History")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading, 16)
                    .padding(.top, 16)
                
                ForEach(historyRecords) { record in
                    HistoryItemView(record: record)
                }
                
                Spacer(minLength: 20)
            }
        }
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.white],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}

#Preview {
    HistoryView()
}
