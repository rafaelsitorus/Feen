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
    private let maxRetries = 3

    // MARK: - Retry Helper

    /// Executes a request, retrying with the next API key on 429 rate-limit errors.
    private func performWithRetry(buildRequest: (String) throws -> URLRequest) async throws -> (Data, HTTPURLResponse) {
        var lastError: Error = GeminiError.noAPIKeys
        for _ in 0..<maxRetries {
            let apiKey = try GeminiKeyRotator.shared.nextKey()
            let request = try buildRequest(apiKey)

            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                throw GeminiError.invalidResponse
            }

            if http.statusCode == 429 {
                let msg = String(data: data, encoding: .utf8) ?? "Rate limited"
                lastError = GeminiError.apiError("Rate limited: \(msg)")
                continue
            }

            guard http.statusCode == 200 else {
                let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw GeminiError.apiError("Gemini API returned \(http.statusCode): \(message)")
            }

            return (data, http)
        }
        throw lastError
    }

    /// Extracts the text content from a Gemini API response.
    private func extractText(from data: Data) throws -> String {
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard
            let candidates = json?["candidates"] as? [[String: Any]],
            let content = candidates.first?["content"] as? [String: Any],
            let parts = content["parts"] as? [[String: Any]],
            let text = parts.first?["text"] as? String
        else {
            throw GeminiError.invalidResponse
        }
        return text
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - News Processing

    /// Rewrites a news title to be more Gen Z catchy, and summarizes the article content.
    /// - Parameters:
    ///   - title: Original title from NewsAPI.
    ///   - content: Article content from NewsAPI.
    /// - Returns: A tuple of (catchyTitle, summary) in Bahasa Indonesia.
    func processNewsArticle(title: String, content: String) async throws -> (catchyTitle: String, summary: String) {
        let prompt = """
        You are a financial news summarizer for Gen Z readers. Your only job is to extract the core facts and rewrite them in plain, casual English.

        ---

        STRICT FILTERING RULES (apply before writing anything):
        - STRIP OUT completely: journalist names, publication names, wire service credits (Reuters, AP, Bloomberg), datelines (e.g., "JAKARTA, June 10 -"), filler phrases ("according to sources", "it is reported that"), and redundant transitional words.
        - KEEP ONLY: the actual event, the key people or entities involved, the cause, the effect, and what happens next (if mentioned).

        ---

        OUTPUT FORMAT — respond ONLY with this JSON, nothing else:
        {"catchyTitle": "...", "summary": "..."}

        CATCHY TITLE rules:
        - Max 12 words
        - Describes the event directly, no clickbait, no questions
        - Written like a headline a smart friend would text you

        SUMMARY rules:
        - Write in flowing paragraphs, NOT bullet points
        - Length: as long as needed to cover all key facts completely — do NOT cut information short
        - Structure: (1) what happened and who is involved, (2) why it happened or what caused it, (3) the impact or consequence, (4) what comes next if mentioned
        - Tone: casual, clear, like explaining to a smart friend who skipped the news today
        - If a financial term appears, explain it simply in parentheses right after — e.g., "inflasi (kenaikan harga barang secara umum)"
        - Zero trailing dots ("..."), zero cliffhangers — every summary must feel complete and resolved
        - No emojis, no markdown, no bullet points, plain text only

        ---

        Article title: \(title)
        Article content: \(content)
        """

        let body: [String: Any] = [
            "contents": [["parts": [["text": prompt]]]],
            "generationConfig": [
                "responseMimeType": "application/json",
            ]
        ]

        let (data, _) = try await performWithRetry { apiKey in
            let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=\(apiKey)")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            return request
        }

        let cleaned = try extractText(from: data)

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

        let (data, _) = try await performWithRetry { apiKey in
            let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=\(apiKey)")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            return request
        }

        let cleaned = try extractText(from: data)
        guard let jsonData = cleaned.data(using: .utf8) else {
            throw GeminiError.invalidResponse
        }
        return try JSONDecoder().decode(InvoiceAnalysis.self, from: jsonData)
    }

    /// Scan a receipt image and extract amount, description, and suggested category.
    func scanReceipt(image: UIImage) async throws -> ReceiptScanResult {
        guard let jpegData = image.jpegData(compressionQuality: 0.8) else {
            throw GeminiError.invalidResponse
        }
        let base64Image = jpegData.base64EncodedString()

        let prompt = """
        You are a receipt scanner. Analyze the attached receipt image and extract the data.

        RULES:
        - Always extract the total amount as an integer (no decimals). If the currency uses decimals, round to nearest whole number.
        - If the receipt has detailed line items (item names, quantities, prices), combine them into a human-readable description string like "2x Nasi Goreng @25000, 1x Es Teh @5000".
        - If the receipt only shows a total amount without clear item details, set description to null.
        - Suggest a category from this list ONLY: Food, Transport, Shopping, Entertainment, Health, Bill. If unsure, set suggestedCategory to null.
        - If the receipt has enough context to determine a category (e.g. restaurant = Food, pharmacy = Health), provide it.

        Respond ONLY with valid JSON (no markdown fences):
        {
          "totalAmount": integer,
          "description": "string or null",
          "suggestedCategory": "string or null"
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
            ],
            "generationConfig": [
                "responseMimeType": "application/json",
            ]
        ]

        let (data, _) = try await performWithRetry { apiKey in
            let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=\(apiKey)")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            return request
        }

        let cleaned = try extractText(from: data)
        guard let jsonData = cleaned.data(using: .utf8) else {
            throw GeminiError.invalidResponse
        }
        return try JSONDecoder().decode(ReceiptScanResult.self, from: jsonData)
    }
    #endif

    /// Generate a micro-summary of an expense relative to the user's financial state.
    func summarizeExpense(
        amount: Int,
        category: String,
        description: String,
        monthlyIncome: Double,
        totalSpent: Int
    ) async throws -> String {
        let remaining = Int(monthlyIncome) - totalSpent
        let percentOfIncome = monthlyIncome > 0 ? (Double(amount) / monthlyIncome * 100) : 0

        let prompt = """
        You are a friendly financial advisor for a Gen Z user. Give a brief, casual micro-summary (3-5 sentences max) about this expense.

        Expense details:
        - Amount: Rp \(amount)
        - Category: \(category)
        - Description: \(description.isEmpty ? "No description" : description)

        User's financial context:
        - Monthly income: Rp \(Int(monthlyIncome))
        - Total spent this period: Rp \(totalSpent)
        - Remaining budget: Rp \(remaining)
        - This expense is \(String(format: "%.1f", percentOfIncome))% of monthly income

        RULES:
        - Be concise, casual, supportive but honest
        - Mention how this expense fits into their overall budget
        - If spending seems high, gently warn. If reasonable, reassure.
        - No emojis, no markdown, plain text only
        - Respond with ONLY the summary text, nothing else
        """

        let body: [String: Any] = [
            "contents": [["parts": [["text": prompt]]]]
        ]

        let (data, _) = try await performWithRetry { apiKey in
            let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=\(apiKey)")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            return request
        }

        let text = try extractText(from: data)
        return text
    }
}
