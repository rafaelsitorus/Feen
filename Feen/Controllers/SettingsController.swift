//
//  SettingsController.swift
//  Feen
//

import Foundation
import Combine

class SettingsController: ObservableObject {
    private let profileKey = "user_profile"
    
    @Published var profile: UserModel {
        didSet {
            LocalStorageManager.shared.save(profile, forKey: profileKey)
        }
    }
    
    init() {
        self.profile =
        LocalStorageManager.shared.load(UserModel.self, forKey: profileKey)
        ?? UserModel()
    }
    
    // MARK: - Profile
    func updateProfile(
        name: String,
        monthlyIncome: Double?,
        sourceOfIncome: SourceOfIncome?,
        monthlyBudget: Double?
    ) {
        profile.name = name
        profile.monthlyIncome = monthlyIncome
        profile.sourceOfIncome = sourceOfIncome
        profile.monthlyBudget = monthlyBudget
    }
    
    // MARK: - Account
    func deleteAccount() {
        profile = UserModel()
        LocalStorageManager.shared.remove(profileKey)
        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
    }
    
    // MARK: - Helpers
    func formattedIncome() -> String {
        guard let income = profile.monthlyIncome else { return "-" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: income)) ?? "-"
    }
    
    func avatarInitial() -> String {
        guard let name = profile.name, !name.isEmpty else { return "?" }
        return String(name.prefix(1)).uppercased()
    }
    
    var displayName: String {
        profile.name ?? "Not set"
    }
    
    var displaySourceOfIncome: String {
        profile.sourceOfIncome?.rawValue ?? "Not set"
    }
}
