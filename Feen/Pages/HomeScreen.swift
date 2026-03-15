//
//  HomeScreen.swift
//  Feen
//
//  Created by Made Vidyatma Adhi Krisna on 11/03/26.
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var settingController: SettingsController
    @EnvironmentObject var budgetController: BudgetController
    
    let historyRecords: [HistoryModel] = [
        HistoryModel(amount: 10000, date: Date(), category: Category.defaultExpenses[0], description: "Lunch at cafe"),
        HistoryModel(amount: 5300000, date: Date(), category: Category.defaultIncomes[0], description: "Apple Developer Academy"),
        HistoryModel(amount: 15000, date: Date(), category: Category.defaultExpenses[1], description: "Bus pass"),
        HistoryModel(amount: 5300000, date: Date(), category: Category.defaultIncomes[0], description: "Apple Developer Academy"),
        HistoryModel(amount: 15000, date: Date(), category: Category.defaultExpenses[1], description: "Bus pass"),
        HistoryModel(amount: 5300000, date: Date(), category: Category.defaultIncomes[0], description: "Apple Developer Academy"),
        HistoryModel(amount: 15000, date: Date(), category: Category.defaultExpenses[1], description: "Bus pass")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hi, \(settingController.displayName)!")
                .font(Font.title3.bold())
                .padding(.leading, 4)
            
            BudgetSummaryComponent(
                todayDate: Date.now.formatted(
                    .dateTime.weekday(.wide).day().month(.wide).year()),
                earned: budgetController.earned,
                spent: budgetController.spent
            )
            
            QuoteComponent(quoteMessage: "Lorem ipsum dolor sit amet consectetur adipiscing elit.")
            
            HistoryComponents(historyRecords: historyRecords, isHome: true)
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }}

#Preview {
    HomeScreen()
}
