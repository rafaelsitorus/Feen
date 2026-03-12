//
//  HistoryController.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 12/03/26.
//

import Foundation
import SwiftData

class HistoryController {
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchHistories() -> [HistoryModel] {
        let request = FetchDescriptor<HistoryModel>()
        
        do {
            let histories = try context.fetch(request)
            print("Fetch histories successfully!")
            return histories
        } catch {
            print("Error fetch histories: \(error)")
            return []
        }
    }
    
    func saveHistory(date: String, category: String, description: String, expense: Int, isEarned: Bool) {
        let history = HistoryModel(date: date, category: category, description: description, expense: expense, isEarned: isEarned)
        context.insert(history)
        
        do {
            try context.save()
            print("New history saved!")
        } catch {
            print("Error saving history: \(history)")
        }
    }
    
    func updateHistory() {
        // Nothing
    }
    
    func deleteHistory() {
        // Nothing
    }
}
