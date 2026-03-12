//
//  OnboardingController.swift
//  Feen
//

import Foundation
import Combine

class OnboardingController: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var profile = UserProfile()  // langsung pakai UserProfile

    let totalSteps = 4

    // MARK: - Navigation

    func goNext() {
        guard currentStep < totalSteps - 1 else { return }
        currentStep += 1
    }

    func goBack() {
        guard currentStep > 0 else { return }
        currentStep -= 1
    }

    var isFirstStep: Bool { currentStep == 0 }
    var isLastStep: Bool { currentStep == totalSteps - 1 }

    // MARK: - Validation per step

    var canProceed: Bool {
        switch currentStep {
        case 0: return !(profile.name?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        case 1: return profile.monthlyIncome != nil
        case 2: return profile.sourceOfIncome != nil
        case 3: return profile.monthlyBudget != nil
        default: return false
        }
    }

    // MARK: - Income helpers

    func setIncome(from text: String) {
        let cleaned = text.replacingOccurrences(of: ".", with: "")
        profile.monthlyIncome = Double(cleaned)
    }

    func setBudget(from text: String) {
        let cleaned = text.replacingOccurrences(of: ".", with: "")
        profile.monthlyBudget = Double(cleaned)
    }

    func formatted(_ value: Double?) -> String {
        guard let value else { return "" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }

    // Overload to support Int? values by delegating to the Double? formatter
    func formatted(_ value: Int?) -> String {
        guard let value else { return "" }
        return formatted(Double(value))
    }

    // MARK: - Finish

    func completeOnboarding(settingsController: SettingsController) {
        // Kirim data langsung ke SettingsController
        settingsController.profile = profile
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
}
