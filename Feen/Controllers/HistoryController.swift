//
//  HistoryController.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 12/03/26.
//

import Foundation
import Combine

class HistoryController: ObservableObject {
    
    private let historyKey = "transaction_history"
    
    @Published var histories: [HistoryModel] = [] {
        didSet {
            saveHistory()
        }
    }
    
    init() {
        loadHistory()
    }
    
    // MARK: - Storage
    
    private func loadHistory() {
        histories =
        LocalStorageManager.shared.load([HistoryModel].self, forKey: historyKey)
        ?? []
    }
    
    private func saveHistory() {
        LocalStorageManager.shared.save(histories, forKey: historyKey)
    }
    
    // MARK: - CRUD
    
    func addTransaction(
        amount: Int,
        category: Category,
        description: String?,
        date: Date = Date()
    ) {
        let newHistory = HistoryModel(
            amount: amount,
            date: date,
            category: category,
            description: description
        )
        
        histories.insert(newHistory, at: 0)
    }
    
    func deleteTransaction(id: UUID) {
        histories.removeAll { $0.id == id }
    }
    
    func clearHistory() {
        histories.removeAll()
    }
}
