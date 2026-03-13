//
//  BudgetSummaryView.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 11/03/26.
//
import SwiftUI

enum BudgetType {
    case earned
    case spent
    
    var color: Color {
        switch self {
        case .earned: return .green
        case .spent: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .earned: return "arrow.up.circle.fill"
        case .spent: return "arrow.down.circle.fill"
        }
    }
}

struct BudgetSummaryComponent: View {
    
    var todayDate: String
    var earned: Int
    var spent: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            header
            
            HStack(spacing: 12) {
                BudgetItem(type: .earned, amount: earned)
                BudgetItem(type: .spent, amount: spent)
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
            )
            
        }
        .padding(16)
        .background(cardBackground)
        .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 0)
    }
}

private extension BudgetSummaryComponent {
    
    var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text(todayDate)
                .font(.subheadline.bold())
                .foregroundColor(.white)
            
            Text("This month spending")
                .font(.caption.bold())
                .foregroundColor(.white)
        }
    }
    
    var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.7),
                        Color.teal
                    ],
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
            )
    }
}

struct BudgetItem: View {
    
    var type: BudgetType
    var amount: Int
    
    var body: some View {
        HStack(spacing: 8) {
            
            Circle()
                .fill(type.color.opacity(0.2))
                .frame(width: 28, height: 28)
                .overlay(
                    Image(systemName: type.icon)
                        .font(.title3)
                        .foregroundColor(type.color)
                )
            
            Text(amount,
                 format: .currency(code: "IDR"))
            .font(.system(size: 12, weight: .bold))
            .monospacedDigit()
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            
            Spacer()
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.greenAccent)
        )
        .padding(6)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    BudgetSummaryComponent(
        todayDate: "Monday, 12 March 2026",
        earned: 999999999999,
        spent: 99
    )
    .padding()
}
