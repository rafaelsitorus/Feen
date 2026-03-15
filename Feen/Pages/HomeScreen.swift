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
            
            HistoryComponents()
            
            Spacer()
        }
        .padding(.horizontal, 28)
    }
}

#Preview {
    HomeScreen()
}
