//
//  Expense.swift
//  Feen
//
//  Created by Juan Fausta Pringadi on 11/03/26.
//

import Foundation

struct Expense: Identifiable, Codable{
    var id: UUID = UUID()
    var amount: Int
    var date: Date
    var category: Category
    var description: String?
    var createdAt: Date = Date()
    var photoPath: String?
}
