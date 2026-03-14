//
//  HistoryView.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 11/03/26.
//

import SwiftUI

struct HistoryComponents: View {
    let historyRecords = [
        HistoryModel(date: "Monday, 11 March 2026", category: "Food", description: "Lunch at cafe", expense: 10000, isEarned: false),
        HistoryModel(date: "Sunday, 10 March 2026", category: "Stipend", description: "Apple Developer Academy", expense: 5300000, isEarned: true),
        HistoryModel(date: "Saturday, 09 March 2026", category: "Transport", description: "Bus pass", expense: 15000, isEarned: false)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title and View All button
            HStack {
                Text("History")
                    .font(.title2.bold())
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    // Action for "View All" button
                    print("View All tapped")
                }) {
                    Text("View All")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }
            .padding([.top, .horizontal])
            
            // History records list
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(historyRecords) { record in
                        HistoryItem(record: record)
                    }
                }
                .padding()
            }
        }
    }
}

struct HistoryItem: View {
    let record: HistoryModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            
            // Left icon indicating earned/spent
            Circle()
                .fill(record.isEarned ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                .frame(width: 38, height: 38)
                .overlay(
                    Image(systemName: record.isEarned ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                        .foregroundColor(record.isEarned ? .green : .red)
                        .font(.title)
                )
            
            // Category and description
            VStack(alignment: .leading, spacing: 8) {
                Text(record.category)
                    .font(.headline.bold())
                    .foregroundColor(.primary)
                
                Text(record.desc)
                    .font(.footnote)
                    .lineLimit(1)
                
                Text(record.date)
                    .font(.caption2)
            }
            
            Spacer()
            
            // Expense amount
            Text(record.expense, format: .currency(code: "IDR"))
                .font(.system(size: 12, weight: .bold))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .foregroundColor(record.isEarned ? .green : .red)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
        )
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 0)
    }
}

#Preview {
    HistoryComponents()
}
