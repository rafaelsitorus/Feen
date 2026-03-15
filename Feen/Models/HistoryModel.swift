//
//  HistoryModel.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 11/03/26.
//

import Foundation

struct HistoryModel: Identifiable, Codable {
    
    var id: UUID = UUID()
    var amount: Int
    var date: Date
    var category: Category
    var description: String?

    var isIncome: Bool {
        category.type == .income
    }
}
