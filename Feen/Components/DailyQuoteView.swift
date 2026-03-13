//
//  DailyQuoteView.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 11/03/26.
//

import SwiftUI

struct DailyQuoteView: View {
    
    let quoteMessage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("“\(quoteMessage)”")
                .font(.title3)
                .fontWeight(.medium)
        }
        .padding(28)
        .frame(maxWidth: .infinity, minHeight: 140, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 52)
                .fill(.white)
        )
        .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 0)
    }
}

#Preview {
    DailyQuoteView(quoteMessage: "Lorem ipsum dolor sit amet consectetur adipiscing elit. Sit amet consectetur adipiscing elit quisque faucibus ex."
    )
    .padding()
}
