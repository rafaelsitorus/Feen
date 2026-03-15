//
//  HomeScreen.swift
//  Feen
//
//  Created by Made Vidyatma Adhi Krisna on 11/03/26.
//

import SwiftUI

// TODO: Add data and create HistoryDetailScreen (*View All clicked)
struct HomeScreen: View {
    @EnvironmentObject var settingController: SettingsController
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hi, \(settingController.displayName)!")
                .font(Font.title3.bold())
                .padding(.leading, 4)
            
            BudgetSummaryComponent(
                todayDate: Date.now.formatted(
                    .dateTime.weekday(.wide).day().month(.wide).year()),
                earned: 999999999999,
                spent: 99
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
