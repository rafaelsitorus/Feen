//
//  Income.swift
//  Feen
//
//  Created by Juan Fausta Pringadi on 12/03/26.
//

import Foundation

enum SourceOfIncome: String, Codable, CaseIterable{
    case salary = "Salary"
    case freelance = "Freelance"
    case business = "Business"
    case investment = "Investment"
    case other = "Other"
}
