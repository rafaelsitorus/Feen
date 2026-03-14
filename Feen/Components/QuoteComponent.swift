//
//  DailyQuoteView.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 11/03/26.
//

import SwiftUI

struct QuoteComponent: View {
    
    let quoteMessage: String
    
    var body: some View {
        VStack {
            
            Text("“\(quoteMessage)”")
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 36)
                .fill(.white)
        )
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 0)
    }
}

#Preview {
    QuoteComponent(quoteMessage: "Lorem ipsum dolor sit amet consectetur adipiscing elit."
    )
    .padding()
}
