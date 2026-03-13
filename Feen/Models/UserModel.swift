//
//  UserModel.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 12/03/26.
//

import Foundation
import SwiftData

@Model
class UserModel {
    var name: String
    var sourceOfIncome: SourceOfIncomeEnum
    
    init(name: String, sourceOfIncome: SourceOfIncomeEnum) {
        self.name = name
        self.sourceOfIncome = sourceOfIncome
    }
}

//struct UserProfile: Codable{
//    var name: String?
//    var monthlyIncome: Double?
//    var sourceOfIncome: SourceOfIncome?
//    var monthlyBudget: Double?
//    
//    var isComplete: Bool{
//        name != nil && monthlyIncome != nil && sourceOfIncome != nil && monthlyBudget != nil
//    }
//}
