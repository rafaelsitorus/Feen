//
//  FeenApp.swift
//  Feen
//
//  Created by Pangihutan Sitorus on 11/03/26.
//

import SwiftUI

@main
struct FeenApp: App {
    @StateObject var expenseController = ExpenseController()
    @StateObject var categoryController = CategoryController()
    @StateObject var settingsController = SettingsController()
    @StateObject var budgetController = BudgetController()
    @StateObject var historyController = HistoryController()

    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(expenseController)
                .environmentObject(categoryController)
                .environmentObject(settingsController)
                .environmentObject(budgetController)
                .environmentObject(historyController)
                .preferredColorScheme(.light)
        }
    }
}
