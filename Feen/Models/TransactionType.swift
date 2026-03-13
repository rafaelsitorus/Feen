import Foundation

enum TransactionType: String, Codable, CaseIterable {
    case expense = "Expense"
    case income  = "Income"
}
