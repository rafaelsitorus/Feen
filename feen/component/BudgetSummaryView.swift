//
//  BudgetSummaryView.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 11/03/26.
//

import SwiftUI

struct BudgetSummaryView: View {
    var todayDate: String
    var earned: Int
    var spent: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text(todayDate)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack {
                BudgetItemView(
                    title: "Earned",
                    amount: earned,
                    color: .green
                )
                
                Spacer()
                
                BudgetItemView(
                    title: "Spent",
                    amount: spent,
                    color: .red
                )
            }
        }
        .padding()
        .frame(width: 320, height: 140, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemGray6))
        )
        .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 0)
    }
}

struct BudgetItemView: View {
    var title: String
    var amount: Int
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text("Rp \(amount)")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(color)
        }
    }
}

#Preview {
    BudgetSummaryView(todayDate: "12 March 2026", earned: 300000, spent: 240000)
}
