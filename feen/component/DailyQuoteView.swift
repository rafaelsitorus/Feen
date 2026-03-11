//
//  DailyQuoteView.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 11/03/26.
//

import SwiftUI

struct DailyQuoteView: View {
    
    // View's params
    let quoteMessage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Daily Quote")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Text("“\(quoteMessage)”")
                .font(.title3)
                .fontWeight(.medium)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 140, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemGray6))
        )
        .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 0)
    }
}

#Preview {
    DailyQuoteView(quoteMessage: "Hello World")
}
