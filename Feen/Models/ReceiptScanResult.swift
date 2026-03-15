//
//  ReceiptScanResult.swift
//  Feen
//

import Foundation

struct ReceiptScanResult: Codable {
    let totalAmount: Int
    let description: String?
    let suggestedCategory: String?
}
