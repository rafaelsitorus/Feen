//
//  LocalStorageManager.swift
//  Feen
//
//  Created by Juan Fausta Pringadi on 11/03/26.
//

import Foundation

class LocalStorageManager {
    static let shared = LocalStorageManager()

    private let expensesKey = "saved_expenses"
    private let categoriesKey = "saved_categories"
    
    private init() {}

    func save<T: Codable>(_ value: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }

    func remove(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    // MARK: - Expenses
    func saveExpenses(_ expenses: [Expense]) {
        if let data = try? JSONEncoder().encode(expenses) {
            UserDefaults.standard.set(data, forKey: expensesKey)
        }
    }

    func loadExpenses() -> [Expense] {
        guard let data = UserDefaults.standard.data(forKey: expensesKey),
              let expenses = try? JSONDecoder().decode([Expense].self, from: data)
        else { return [] }
        return expenses
    }

    // MARK: - Categories
    func saveCategories(_ categories: [Category]) {
        let customOnly = categories.filter { $0.isCustom }
        if let data = try? JSONEncoder().encode(customOnly) {
            UserDefaults.standard.set(data, forKey: categoriesKey)
        }
    }

    func loadCategories() -> [Category] {
        var all = Category.defaultIncomes + Category.defaultExpenses
        if let data = UserDefaults.standard.data(forKey: categoriesKey),
           let custom = try? JSONDecoder().decode([Category].self, from: data) {
            all += custom
        }
        return all
    }
}
