//
//  InvoiceAnalysis.swift
//  Feen
//
//  Created by Pangihutan Sitorus on 11/03/26.
//

import Foundation

struct LineItem: Codable, Identifiable {
    var id: String { description }
    let description: String
    let amount: Double
}

struct InvoiceAnalysis: Codable {
    let vendorName: String
    let invoiceDate: String
    let lineItems: [LineItem]
    let totalAmount: Double
    let percentageOfWage: Double
    let healthRating: String
    let summary: String
    let tip: String
}
