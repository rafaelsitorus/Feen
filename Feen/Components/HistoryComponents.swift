//
//  HistoryView.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 11/03/26.
//

import SwiftUI

struct HistoryComponents: View {
    let historyRecords: [HistoryModel] = [
        HistoryModel(
            amount: 10000,
            date: Date(),
            category: Category.defaultExpenses[0],
            description: "Lunch at cafe"
        ),
        HistoryModel(
            amount: 5300000,
            date: Date(),
            category: Category.defaultIncomes[0],
            description: "Apple Developer Academy"
        ),
        HistoryModel(
            amount: 15000,
            date: Date(),
            category: Category.defaultExpenses[1],
            description: "Bus pass"
        ),
        HistoryModel(
            amount: 5300000,
            date: Date(),
            category: Category.defaultIncomes[0],
            description: "Apple Developer Academy"
        ),
        HistoryModel(
            amount: 15000,
            date: Date(),
            category: Category.defaultExpenses[1],
            description: "Bus pass"
        ),
        HistoryModel(
            amount: 5300000,
            date: Date(),
            category: Category.defaultIncomes[0],
            description: "Apple Developer Academy"
        ),
        HistoryModel(
            amount: 15000,
            date: Date(),
            category: Category.defaultExpenses[1],
            description: "Bus pass"
        )
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
                    ForEach(historyRecords.prefix(5)) { record in
                        HistoryItem(record: record)
                    }
                }
                .padding()
            }
        }
        .padding(.bottom, 60)
    }
}

struct HistoryItem: View {
    
    let record: HistoryModel
    
    var body: some View {
        
        HStack(spacing: 16) {
            
            // Icon
            ZStack {
                Circle()
                    .fill(record.isIncome ? .green.opacity(0.15) : .red.opacity(0.15))
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

#Preview {
    HistoryComponents()
}
