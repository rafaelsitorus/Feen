import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var controller: SettingsController
    @StateObject private var editController = EditProfileController()

    @State private var showEditProfile = false
    @State private var showDeleteAlert = false

    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        ProfileCardView(
                            avatarInitial: controller.avatarInitial(),
                            displayName: controller.displayName,
                            displaySourceOfIncome: controller.displaySourceOfIncome,
                            formattedIncome: controller.formattedIncome(),
                            onEditTap: {
                                editController.load(from: controller.profile)
                                showEditProfile = true
                            }
                        )

                        profileSection
                        preferencesSection
                        aboutSection
                        accountSection

                        Spacer().frame(height: 100)
                    }
                    .padding(.top, 12)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showEditProfile) {
            EditProfileView(
                controller: editController,
                onSave: { name, income, source in
                    if let income = income {
                        controller.updateProfile(name: name, monthlyIncome: Double(income), sourceOfIncome: source, monthlyBudget: Double())
                    }
                    showEditProfile = false
                },
                onCancel: { showEditProfile = false }
            )
        }
        .alert("Delete Account", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) { controller.deleteAccount() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure? All your data will be permanently deleted and cannot be recovered.")
        }
    }

    // MARK: - Sections

    private var profileSection: some View {
        SettingsSectionCard(title: "Profile") {
            SettingsRow(
                icon: "person.text.rectangle",
                iconColor: AppTheme.teal,
                title: "Full Name",
                subtitle: controller.displayName,
                showChevron: false
            )
            Divider().padding(.leading, 68)
            SettingsRow(
                icon: "banknote",
                iconColor: Color(red: 0.2, green: 0.7, blue: 0.4),
                title: "Monthly Income",
                subtitle: controller.formattedIncome(),
                showChevron: false
            )
            Divider().padding(.leading, 68)
            SettingsRow(
                icon: "briefcase",
                iconColor: Color(red: 0.3, green: 0.5, blue: 0.9),
                title: "Source of Income",
                subtitle: controller.displaySourceOfIncome,
                showChevron: false
            )
        }
    }

    private var preferencesSection: some View {
        SettingsSectionCard(title: "Preferences") {
            SettingsRow(
                icon: "dollarsign.circle",
                iconColor: Color(red: 0.9, green: 0.6, blue: 0.1),
                title: "Currency",
                trailingText: controller.settings.selectedCurrency,
                showChevron: true
            )
            Divider().padding(.leading, 68)
            SettingsToggleRow(
                icon: "bell",
                iconColor: Color(red: 0.9, green: 0.4, blue: 0.3),
                title: "Notifications",
                subtitle: "Daily spending reminders",
                isOn: Binding(
                    get: { controller.settings.notificationsEnabled },
                    set: { _ in controller.toggleNotifications() }
                )
            )
        }
    }

    private var aboutSection: some View {
        SettingsSectionCard(title: "About") {
            SettingsRow(
                icon: "star",
                iconColor: Color(red: 1.0, green: 0.75, blue: 0.0),
                title: "Rate the App",
                showChevron: true
            )
            Divider().padding(.leading, 68)
            SettingsRow(
                icon: "lock.shield",
                iconColor: AppTheme.teal,
                title: "Privacy Policy",
                showChevron: true
            )
            Divider().padding(.leading, 68)
            SettingsRow(
                icon: "doc.text",
                iconColor: AppTheme.textSecondary,
                title: "Terms of Service",
                showChevron: true
            )
            Divider().padding(.leading, 68)
            SettingsRow(
                icon: "info.circle",
                iconColor: Color(red: 0.3, green: 0.5, blue: 0.9),
                title: "App Version",
                trailingText: "\(controller.settings.appVersion) (\(controller.settings.buildNumber))",
                showChevron: false
            )
        }
    }

    private var accountSection: some View {
        SettingsSectionCard(title: "Account") {
            SettingsRow(
                icon: "trash",
                iconColor: Color(red: 0.9, green: 0.2, blue: 0.2),
                title: "Delete Account",
                showChevron: true,
                action: { showDeleteAlert = true }
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsController())
    }
}
