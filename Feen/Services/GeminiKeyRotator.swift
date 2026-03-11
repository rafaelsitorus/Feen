//
//  GeminiKeyRotator.swift
//  Feen
//
//  Created by Pangihutan Sitorus on 11/03/26.
//

import Foundation

/// Rotates through an array of Gemini API keys using round-robin.
/// Add as many keys as you like to the `apiKeys` array below.
final class GeminiKeyRotator: @unchecked Sendable {
    static let shared = GeminiKeyRotator()

    // MARK: – Add your Gemini API keys here
    private let apiKeys: [String] = [
        "AIzaSyBC4N8IxxtZYViyO6uDkjv80M22i3exHZU"
        // "YOUR_GEMINI_API_KEY_2",
        // "YOUR_GEMINI_API_KEY_3",
    ]

    private var currentIndex = 0
    private let lock = NSLock()

    private init() {}

    /// Returns the next API key in round-robin order.
    /// - Throws: If no keys are configured.
    func nextKey() throws -> String {
        lock.lock()
        defer { lock.unlock() }
        guard !apiKeys.isEmpty else {
            throw GeminiError.noAPIKeys
        }
        let key = apiKeys[currentIndex % apiKeys.count]
        currentIndex += 1
        return key
    }
}

enum GeminiError: LocalizedError {
    case noAPIKeys
    case invalidResponse
    case apiError(String)

    var errorDescription: String? {
        switch self {
        case .noAPIKeys:
            return "No Gemini API keys configured. Add keys to GeminiKeyRotator."
        case .invalidResponse:
            return "Received an invalid response from Gemini."
        case .apiError(let message):
            return message
        }
    }
}
