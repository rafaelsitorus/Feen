//
//  HistoryModel.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 11/03/26.
//

import Foundation
import SwiftData

@Model
class HistoryModel {
    var date: String
    var category: String
    var desc: String
    var expense: Int
    var isEarned: Bool
    
    init(date: String, category: String, description: String, expense: Int, isEarned: Bool) {
        self.date = date
        self.category = category
        self.desc = description
        self.expense = expense
        self.isEarned = isEarned
    }
}
