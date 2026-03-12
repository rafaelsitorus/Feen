//
//  SettingsController.swift
//  Feen
//

import Foundation
import Combine

class SettingsController: ObservableObject {
    @Published var profile = UserProfile()
    @Published var settings = AppSettings()

    // MARK: - Profile

    func updateProfile(name: String, monthlyIncome: Double?, sourceOfIncome: SourceOfIncome?, monthlyBudget: Double?) {
        profile.name = name
        profile.monthlyIncome = monthlyIncome
        profile.sourceOfIncome = sourceOfIncome
        profile.monthlyBudget = monthlyBudget
    }

    // MARK: - Preferences

    func toggleNotifications() {
        settings.notificationsEnabled.toggle()
    }

    func updateCurrency(_ currency: String) {
        settings.selectedCurrency = currency
    }

    // MARK: - Account

    func deleteAccount() {
        profile = UserProfile()
        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
    }

    // MARK: - Helpers

    func formattedIncome() -> String {
        guard let income = profile.monthlyIncome else { return "-" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: income)) ?? "-"
    }

    func avatarInitial() -> String {
        guard let name = profile.name, !name.isEmpty else { return "?" }
        return String(name.prefix(1)).uppercased()
    }

    var displayName: String { profile.name ?? "Not set" }
    var displaySourceOfIncome: String { profile.sourceOfIncome?.rawValue ?? "Not set" }
}
