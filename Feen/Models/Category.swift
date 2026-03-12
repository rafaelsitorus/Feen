//
//  Category.swift
//  Feen
//
//  Created by Juan Fausta Pringadi on 11/03/26.
//

import Foundation


struct Category: Identifiable, Codable, Equatable{
    var id: UUID = UUID()
    var name: String
    var icon: String
    var type: TransactionType
    var isCustom: Bool = false
    
    static let defaultExpenses: [Category] = [
        Category(name: "Food", icon: "fork.knife", type: .expense),
        Category(name: "Transport", icon: "car.fill", type: .expense),
        Category(name: "Shopping", icon: "bag.fill", type: .expense),
        Category(name: "Entertainment", icon: "gamecontroller.fill", type: .expense),
        Category(name: "Health", icon: "heart.fill", type: .expense),
        Category(name: "Bill", icon: "doc.text.fill", type: .expense),
    ]
    
    static let defaultIncomes: [Category] = [
        Category(name: "Salary", icon: "banknote.fill", type: .income),
        Category(name: "Invest", icon: "chart.line.uptrend.xyaxis", type: .income),
        Category(name: "Donation", icon: "gift.fill", type: .income),
        Category(name: "Other", icon: "ellipsis.circle.fill", type: .income)
    ]
}
