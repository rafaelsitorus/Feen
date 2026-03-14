//
//  HomeScreen.swift
//  Feen
//
//  Created by Made Vidyatma Adhi Krisna on 11/03/26.
//

import SwiftUI

// TODO: Add data and create HistoryDetailScreen (*View All clicked)
struct HomeScreen: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hi, Made!")
                .font(Font.title3.bold())
                .padding(.leading, 4)
            
            BudgetSummaryComponent(
                todayDate: "Monday, 12 March 2026",
                earned: 999999999999,
                spent: 99
            )
            
            QuoteComponent(quoteMessage: "Lorem ipsum dolor sit amet consectetur adipiscing elit.")
            
            HistoryComponents()
            
            Text("[Chart View (Optional)]")
                .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    HomeScreen()
}
