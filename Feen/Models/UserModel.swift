//
//  UserModel.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 12/03/26.
//

import Foundation

struct UserModel: Codable{
    var name: String?
    var monthlyIncome: Double?
    var sourceOfIncome: SourceOfIncome?
    var monthlyBudget: Double?
    
    var isComplete: Bool{
        name != nil && monthlyIncome != nil && sourceOfIncome != nil && monthlyBudget != nil
    }
}
