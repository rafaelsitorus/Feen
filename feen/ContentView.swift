//
//  ContentView.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 11/03/26.
//

import SwiftUI
import SwiftData

// TESTING VIEW
struct ContentView: View {
    @Environment(\.modelContext) private var context
    
    var body: some View {
        Button("Test Controller") {
            
            let controller = BudgetController(context: context)
            
            controller.saveBudget(earned: 1000, spent: 500)
            
            if let budget = controller.fetchBudget() {
                print("Earned:", budget.earned)
                print("Spent:", budget.spent)
            } else {
                print("No budget found")
            }
        }
    }
}

#Preview {
    ContentView()
}
