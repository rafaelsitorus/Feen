//
//  AllHistoryScreen.swift
//  Feen
//
//  Created by Fidel Fausta Cavell on 15/03/26.
//

import SwiftUI

struct AllHistoryScreen: View {
    var historyRecords: [HistoryModel]
    
    var body: some View {
        HistoryComponents(historyRecords: historyRecords, isHome: false)
            .padding(.horizontal, 18)
    }
}

#Preview {
    let sampleHistory: [HistoryModel] = [
        HistoryModel(amount: 100, date: Date(), category: .defaultExpenses[1], description: "Lunch"),
        HistoryModel(amount: 50, date: Date(), category: .defaultIncomes[0], description: "Bus fare"),
        HistoryModel(amount: 200, date: Date(), category: .defaultExpenses[2], description: "Groceries")
    ]
    
    AllHistoryScreen(historyRecords: sampleHistory)
}
