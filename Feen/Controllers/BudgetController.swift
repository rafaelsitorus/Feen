//
//  BudgetController.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 12/03/26.
//

import Foundation
import Combine

class BudgetController: ObservableObject {
    
    static let shared = BudgetController()
    
    private let earnedKey = "budget_earned"
    private let spentKey = "budget_spent"
    
    @Published var earned: Int = 0 {
        didSet { LocalStorageManager.shared.save(earned, forKey: earnedKey) }
    }
    
    @Published var spent: Int = 0 {
        didSet { LocalStorageManager.shared.save(spent, forKey: spentKey) }
    }
    
    init() {
        // Load saved budget or initialize to 0
        earned = LocalStorageManager.shared.load(Int.self, forKey: earnedKey) ?? 0
        spent = LocalStorageManager.shared.load(Int.self, forKey: spentKey) ?? 0
    }
    
    // MARK: - Budget Updates
    
    func addIncome(_ amount: Int) {
        earned += amount
    }
    
    func addExpense(_ amount: Int) {
        spent += amount
    }
    
    func resetBudget() {
        earned = 0
        spent = 0
    }
    
    // Convenience: fetch full budget as a model
    func fetchBudget() -> BudgetModel {
        return BudgetModel(earned: earned, spent: spent)
    }
    
    // Convenience: set budget manually
    func saveBudget(earned: Int, spent: Int) {
        self.earned = earned
        self.spent = spent
    }
}
