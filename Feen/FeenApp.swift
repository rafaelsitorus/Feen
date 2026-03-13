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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(expenseController)
                .environmentObject(categoryController)
                .environmentObject(settingsController)
                .preferredColorScheme(.light)
        }
    }
}
