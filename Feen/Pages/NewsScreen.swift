//
//  NewsScreen.swift
//  Feen
//
//  Created by Made Vidyatma Adhi Krisna on 11/03/26.
//

import SwiftUI

// TODO: Add data and create modal to show news detail (*Card clicked)
struct NewsScreen: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Latest Financial News")
                .font(Font.title3.bold())
                .padding([.top, .leading])
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(1...5, id: \.self) { news in
                        NewsCardComponent(
                            imageName: "photo",
                            date: "11 / 03 / 2026",
                            quote: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt."
                        )
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    NewsScreen()
}
