//
//  BudgetController.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 12/03/26.
//

import Foundation
import SwiftData

class BudgetController {
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchBudget() -> BudgetModel? {
        let request = FetchDescriptor<BudgetModel>()
        
        do {
            let budget = try context.fetch(request).first
            print("Fetch budget successful!")
            return budget
            
        } catch {
            print("Error fetching budget: \(error)")
            return nil
        }
    }
    
    func saveBudget(earned: Int, spent: Int) {
        let savedBudget = BudgetModel(earned: earned, spent: spent)
        context.insert(savedBudget)
        
        do {
            try context.save()
            print("New budget saved!")
        } catch {
            print("Error saving budget: \(error)")
        }
    }
}
