//
//  HistoryModel.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 11/03/26.
//

import Foundation

struct HistoryModel: Identifiable {
    let id = UUID()
    let date: String
    let category: String
    let description: String
    let expense: Int
    let isEarned: Bool
}
