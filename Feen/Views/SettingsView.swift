import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var controller: SettingsController
    @StateObject private var editController = EditProfileController()
    
    @State private var showEditProfile = false
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Settings")
                .font(.headline.bold())
            
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
            .frame(height: 160)
            
            profileSection
            accountSection
            
            Spacer()
        }
        .padding(.top, 16)
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
