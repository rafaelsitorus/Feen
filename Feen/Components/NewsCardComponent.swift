//
//  NewsCardView.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 11/03/26.
//

import SwiftUI

struct NewsCardComponent: View {
    var imageURL: String?
    var date: String
    var quote: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Image header
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue.opacity(0.25))
                    .frame(height: 140)
                
                if let imageURL = imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 140)
                                .clipped()           // ← ini yang penting, supaya tidak overflow keluar card
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        case .failure(_), .empty:
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundStyle(.black.opacity(0.7))
                        @unknown default:
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundStyle(.black.opacity(0.7))
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundStyle(.black.opacity(0.7))
                }
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
    }
}

#Preview {
    NewsCardComponent(
        imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/PNG_transparency_demonstration_1.png/280px-PNG_transparency_demonstration_1.png",
        date: "11 / 03 / 2026",
        quote: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt."
    )
}
