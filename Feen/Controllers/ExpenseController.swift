//
//  ExpenseController.swift
//  Feen
//
//  Created by Juan Fausta Pringadi on 11/03/26.
//

import Foundation
import Combine

class ExpenseController: ObservableObject {
    @Published var expenses: [Expense] = []

    init() {
        expenses = LocalStorageManager.shared.loadExpenses()
    }

    func addExpense(amount: Int, date: Date, category: Category,
                    description: String, photoPath: String? = nil) {
        let expense = Expense(
            amount: amount,
            date: date,
            category: category,
            description: description,
            photoPath: photoPath
        )
        expenses.append(expense)
        LocalStorageManager.shared.saveExpenses(expenses)
    }

    func deleteExpense(id: UUID) {
        expenses.removeAll { $0.id == id }
        LocalStorageManager.shared.saveExpenses(expenses)
    }
}
