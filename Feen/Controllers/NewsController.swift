//
//  NewsController.swift
//  Feen
//
//  Created by Juan Fausta Pringadi on 14/03/26.
//

import Foundation
import Combine

struct ProcessedNews: Identifiable {
    let id: UUID
    let catchyTitle: String
    let urlToImage: String?
    let publishedAt: String
    let summary: String
}

class NewsController: ObservableObject {
    @Published var processedNews: [ProcessedNews] = []
    @Published var isLoading: Bool = false

    private let newsAPIKey = "bed13a4f10584b0292f5b986277c243b"

    func fetchAndProcess() async {
        await MainActor.run {
            self.isLoading = true
            self.processedNews = []
        }

        do {
            let articles = try await fetchFinancialNews()

            for article in articles.prefix(10) {
                let rawContent = article.content ?? article.title
                let cleanedContent = cleanContent(rawContent)

                do {
                    let (catchyTitle, summary) = try await GeminiService.shared.processNewsArticle(
                        title: article.title,
                        content: cleanedContent
                    )
                    let processed = ProcessedNews(
                        id: article.id,
                        catchyTitle: catchyTitle,
                        urlToImage: article.urlToImage,
                        publishedAt: formatDate(article.publishedAt),
                        summary: summary
                    )
                    await MainActor.run { self.processedNews.append(processed) }
                } catch {
                    // Fallback: pakai judul & konten asli kalau Gemini gagal
                    let processed = ProcessedNews(
                        id: article.id,
                        catchyTitle: article.title,
                        urlToImage: article.urlToImage,
                        publishedAt: formatDate(article.publishedAt),
                        summary: cleanedContent
                    )
                    await MainActor.run { self.processedNews.append(processed) }
                    print("Gemini error for article '\(article.title)': \(error.localizedDescription)")
                }
            }

            await MainActor.run { self.isLoading = false }
        } catch {
            print("News fetch error: \(error.localizedDescription)")
            await MainActor.run { self.isLoading = false }
        }
    }

    // MARK: - Fetch from NewsAPI

    private func fetchFinancialNews() async throws -> [NewsModel] {
        var components = URLComponents(string: "https://newsapi.org/v2/everything")!
        components.queryItems = [
            URLQueryItem(name: "q", value: "finance OR investing OR stocks OR economy OR market OR trading OR cryptocurrency OR financial"),
//            URLQueryItem(name: "category", value: "finance OR business OR economics"),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "sortBy", value: "publishedAt"),
            URLQueryItem(name: "pageSize", value: "10")
        ]

        var request = URLRequest(url: components.url!)
        request.setValue(newsAPIKey, forHTTPHeaderField: "X-Api-Key")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(NewsResponse.self, from: data).articles
    }

    // MARK: - Helpers

    /// Strips HTML tags and the NewsAPI "[+N chars]" truncation marker
    private func cleanContent(_ raw: String) -> String {
        var cleaned = raw.replacingOccurrences(
            of: #"\s*\[\+\d+ chars\]"#,
            with: "",
            options: .regularExpression
        )

        cleaned = cleaned.replacingOccurrences(
            of: "<[^>]+>",
            with: " ",
            options: .regularExpression
        )

        cleaned = cleaned.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return cleaned
    }

    private func formatDate(_ isoDate: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        var date = formatter.date(from: isoDate)

        if date == nil {
            let fallback = ISO8601DateFormatter()
            fallback.formatOptions = [.withInternetDateTime]
            date = fallback.date(from: isoDate)
        }

        guard let resolved = date else { return isoDate }

        let display = DateFormatter()
        display.dateFormat = "dd / MM / yyyy"
        return display.string(from: resolved)
    }
}
