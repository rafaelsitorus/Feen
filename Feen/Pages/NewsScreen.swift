//
//  NewsScreen.swift
//  Feen
//
//  Created by Made Vidyatma Adhi Krisna on 11/03/26.
//

import SwiftUI

// TODO: Add data and create modal to show news detail (*Card clicked)
struct NewsScreen: View {
    @StateObject var controller = NewsController()
    @State var selectedNews: ProcessedNews?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if controller.isLoading {
                    Spacer()
                    ProgressView("Loading News...")
                        .frame(maxWidth: .infinity)
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(controller.processedNews) { news in
                                NewsCardComponent(
                                    imageName: news.urlToImage ?? "",
                                    date: news.publishedAt,
                                    quote: news.catchyTitle
                                )
                                .onTapGesture {
                                    selectedNews = news
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Latest Financial News")
        }
        .task {
            await controller.fetchAndProcess()
        }
        .sheet(item: $selectedNews) { news in
            NewsDetailModal(news: news)
        }
    }
}

// MARK: - Modal

struct NewsDetailModal: View {
    let news: ProcessedNews
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Close button
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
                }

                // Image
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blue.opacity(0.25))
                        .frame(height: 200)

                    if let imageURL = news.urlToImage, let url = URL(string: imageURL) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        } placeholder: {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundStyle(.black.opacity(0.7))
                        }
                    } else {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.black.opacity(0.7))
                    }
                }

                // Date
                Text(news.publishedAt)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)

                // Catchy Title
                Text(news.catchyTitle)
                    .font(.title3.bold())
                    .multilineTextAlignment(.leading)

                Divider()

                // Summary
                Text(news.summary)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(6)

                Spacer()
            }
            .padding()
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    NewsScreen()
}
