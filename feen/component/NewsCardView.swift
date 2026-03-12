//
//  NewsCardView.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 11/03/26.
//

import SwiftUI

struct NewsCardView: View {
    var imageName: String
    var date: String
    var quote: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Image header
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue.opacity(0.25))
                    .frame(height: 140)
                
                Image(systemName: imageName)
                    .font(.largeTitle)
                    .foregroundStyle(.black.opacity(0.7))
            }
            
            // Date
            HStack {
                Spacer()
                Text(date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // Quote text
            Text("\"\(quote)\"")
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
        )
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 0)
        .padding()
    }}

#Preview {
    NewsCardView(
        imageName: "photo",
        date: "11 / 03 / 2026",
        quote: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt."
    )
}
