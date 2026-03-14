//
//  GeminiService.swift
//  Feen
//
//  Created by Pangihutan Sitorus on 11/03/26.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

final class GeminiService {
    static let shared = GeminiService()
    private init() {}

    private let session = URLSession.shared

    // MARK: - News Processing

    /// Rewrites a news title to be more Gen Z catchy, and summarizes the article content.
    /// - Parameters:
    ///   - title: Original title from NewsAPI.
    ///   - content: Article content from NewsAPI.
    /// - Returns: A tuple of (catchyTitle, summary) in Bahasa Indonesia.
    func processNewsArticle(title: String, content: String) async throws -> (catchyTitle: String, summary: String) {
        let apiKey = try GeminiKeyRotator.shared.nextKey()
        let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=\(apiKey)")!

        let prompt = """
        You are a Gen Z financial content writer. Given a news article title and content, do exactly two things:

        1. CATCHY TITLE: Rewrite the title to be engaging and relatable for Gen Z readers. Stay true to the article's topic. Maximum 12 words. Must be in English.

        2. SUMMARY: Summarize the article in approximately 3-4 sentences. Use casual, easy-to-understand English for people who are financially illiterate. If you must use a financial term, briefly explain it in parentheses. Must be in English.

        Article title: \(title)
        Article content: \(content)

        YOU MUST respond ONLY with this exact JSON format, nothing else, no markdown, no explanation:
        {"catchyTitle":"string","summary":"string"}
        """

        let body: [String: Any] = [
            "contents": [["parts": [["text": prompt]]]]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw GeminiError.invalidResponse
        }
        guard http.statusCode == 200 else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw GeminiError.apiError("Gemini API returned \(http.statusCode): \(message)")
        }

        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard
            let candidates = json?["candidates"] as? [[String: Any]],
            let content = candidates.first?["content"] as? [String: Any],
            let parts = content["parts"] as? [[String: Any]],
            let text = parts.first?["text"] as? String
        else {
            throw GeminiError.invalidResponse
        }

        let cleaned = text
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard
            let start = cleaned.firstIndex(of: "{"),
            let end = cleaned.lastIndex(of: "}"),
            start <= end
        else {
            throw GeminiError.invalidResponse
        }

        let jsonString = String(cleaned[start...end])

        guard
            let jsonData = jsonString.data(using: .utf8),
            let parsed = try? JSONSerialization.jsonObject(with: jsonData) as? [String: String],
            let catchyTitle = parsed["catchyTitle"],
            let summary = parsed["summary"],
            !catchyTitle.isEmpty,
            !summary.isEmpty
        else {
            throw GeminiError.invalidResponse
        }

        return (catchyTitle, summary)
    }

    // MARK: - Invoice Analysis

    #if canImport(UIKit)
    /// Analyze an invoice image with Gemini.
    /// - Parameters:
    ///   - image: The captured invoice photo.
    ///   - monthlyWage: The user's stated monthly income.
    /// - Returns: An `InvoiceAnalysis` parsed from Gemini's response.
    func analyzeInvoice(image: UIImage, monthlyWage: Double) async throws -> InvoiceAnalysis {
        guard let jpegData = image.jpegData(compressionQuality: 0.8) else {
            throw GeminiError.invalidResponse
        }
        let base64Image = jpegData.base64EncodedString()
        let apiKey = try GeminiKeyRotator.shared.nextKey()
        let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=\(apiKey)")!

        let prompt = """
        You are a financial analyst. The user earns a monthly wage of \(String(format: "%.0f", monthlyWage)).
        Analyze the attached invoice image. Extract:
        1. The vendor / merchant name
        2. The invoice date
        3. Each line item with its amount
        4. The total amount on the invoice

        Then provide a short financial-health summary:
        - What percentage of their monthly wage this invoice represents.
        - Whether this spending level is healthy, moderate, or concerning.
        - One actionable tip.

        Respond ONLY with valid JSON (no markdown fences) in this exact format:
        {
          "vendorName": "string",
          "invoiceDate": "string",
          "lineItems": [{"description": "string", "amount": number}],
          "totalAmount": number,
          "percentageOfWage": number,
          "healthRating": "healthy | moderate | concerning",
          "summary": "string",
          "tip": "string"
        }
        """

        let body: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt],
                        [
                            "inline_data": [
                                "mime_type": "image/jpeg",
                                "data": base64Image
                            ]
                        ]
                    ]
                ]
            ]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw GeminiError.invalidResponse
        }
        guard http.statusCode == 200 else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw GeminiError.apiError("Gemini API returned \(http.statusCode): \(message)")
        }

        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard
            let candidates = json?["candidates"] as? [[String: Any]],
            let content = candidates.first?["content"] as? [String: Any],
            let parts = content["parts"] as? [[String: Any]],
            let text = parts.first?["text"] as? String
        else {
            throw GeminiError.invalidResponse
        }

        let cleaned = text
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let jsonData = cleaned.data(using: .utf8) else {
            throw GeminiError.invalidResponse
        }

        let analysis = try JSONDecoder().decode(InvoiceAnalysis.self, from: jsonData)
        return analysis
    }
    #endif
}
