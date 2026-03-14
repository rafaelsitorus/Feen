//
//  BudgetModel.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 12/03/26.
//

import Foundation
import SwiftData

@Model
class BudgetModel {
    var earned: Int
    var spent: Int
    
    init(earned: Int, spent: Int) {
        self.earned = earned
        self.spent = spent
    }
}
