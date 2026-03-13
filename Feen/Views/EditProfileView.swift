import SwiftUI

struct EditProfileView: View {
    @ObservedObject var controller: EditProfileController
    let onSave: (String, Double?, SourceOfIncome?) -> Void
    let onCancel: () -> Void

    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        avatarPreview
                        formFields
                        saveButton
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: onCancel)
                        .foregroundColor(AppTheme.teal)
                }
            }
        }
    }

    // MARK: - Subviews

    private var avatarPreview: some View {
        ZStack {
            Circle()
                .fill(AppTheme.tealGradient)
                .frame(width: 80, height: 80)
            Text(String(controller.name.prefix(1)).uppercased().isEmpty ? "?" : String(controller.name.prefix(1)).uppercased())
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.top, 8)
    }

    private var formFields: some View {
        VStack(spacing: 16) {
            EditFieldCard(
                title: "Full Name",
                placeholder: "Enter your name",
                text: $controller.name
            )
            incomeField
            sourceOfIncomeField
        }
        .padding(.horizontal, 20)
    }

    private var incomeField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Monthly Income")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
                .padding(.horizontal, 4)

            HStack {
                Text("Rp")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.teal)
                    .padding(.leading, 16)

                TextField("0", text: $controller.incomeText)
                    .keyboardType(.numberPad)
                    .font(.system(size: 16))
                    .foregroundColor(AppTheme.textPrimary)
                    .padding(.vertical, 14)
                    .padding(.trailing, 16)
            }
            .background(AppTheme.card)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppTheme.teal.opacity(0.3), lineWidth: 1)
            )
        }
    }

    private var sourceOfIncomeField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Source of Income")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
                .padding(.horizontal, 4)

            Menu {
                // CaseIterable — otomatis semua case muncul tanpa hardcode
                ForEach(controller.incomeSources, id: \.self) { source in
                    Button(source.rawValue) {
                        controller.sourceOfIncome = source
                    }
                }
            } label: {
                HStack {
                    Text(controller.sourceOfIncome?.rawValue ?? "Select source")
                        .font(.system(size: 16))
                        .foregroundColor(controller.sourceOfIncome == nil ? AppTheme.textSecondary : AppTheme.textPrimary)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textSecondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(AppTheme.card)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppTheme.teal.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }

    private var saveButton: some View {
        Button {
            onSave(controller.name, controller.parsedIncome(), controller.sourceOfIncome)
        } label: {
            Text("Save Changes")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    Group {
                        if controller.isValid {
                            AnyView(AppTheme.tealGradientHorizontal)
                        } else {
                            AnyView(Color.gray.opacity(0.4))
                        }
                    }
                )
                .cornerRadius(14)
        }
        .disabled(!controller.isValid)
        .padding(.horizontal, 20)
    }
}
