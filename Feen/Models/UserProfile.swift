//
//  UserProfile.swift
//  Feen
//
//  Created by Juan Fausta Pringadi on 12/03/26.
//

import Foundation

struct UserProfile: Codable{
    var name: String?
    var monthlyIncome: Double?
    var sourceOfIncome: SourceOfIncome?
    var monthlyBudget: Double?
    
    var isComplete: Bool{
        name != nil && monthlyIncome != nil && sourceOfIncome != nil && monthlyBudget != nil
    }
}
