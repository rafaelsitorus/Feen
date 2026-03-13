import Foundation
import Combine

class EditProfileController: ObservableObject {
    @Published var name: String = ""
    @Published var incomeText: String = ""
    @Published var sourceOfIncome: SourceOfIncome? = nil  // Optional enum

    // Langsung dari CaseIterable, tidak perlu hardcode array lagi
    let incomeSources = SourceOfIncome.allCases

    func load(from profile: UserModel) {
        name = profile.name ?? ""
        sourceOfIncome = profile.sourceOfIncome

        if let income = profile.monthlyIncome {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = "."
            formatter.maximumFractionDigits = 0
            incomeText = formatter.string(from: NSNumber(value: income)) ?? ""
        } else {
            incomeText = ""
        }
    }

    func parsedIncome() -> Double? {
        let cleaned = incomeText.replacingOccurrences(of: ".", with: "")
        return Double(cleaned)
    }

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        parsedIncome() != nil &&
        sourceOfIncome != nil
    }
}
