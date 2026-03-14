//
//  OnboardingContainerView.swift
//  Feen
//

import SwiftUI

struct OnboardingContainerView: View {
    @StateObject private var controller = OnboardingController()
    var onFinished: (UserModel) -> Void

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress bar + back button
                headerBar

                // Step content
                TabView(selection: $controller.currentStep) {
                    OnboardingNameView(name: Binding(
                        get: { controller.profile.name ?? "" },
                        set: { controller.profile.name = $0.isEmpty ? nil : $0 }
                    ))
                    .tag(0)

                    OnboardingIncomeView(
                        incomeText: Binding(
                            get: { controller.formatted(controller.profile.monthlyIncome) },
                            set: { controller.setIncome(from: $0) }
                        ),
                        name: controller.profile.name ?? ""
                    )
                    .tag(1)

                    OnboardingSourceView(
                        selected: Binding(
                            get: { controller.profile.sourceOfIncome },
                            set: { controller.profile.sourceOfIncome = $0 }
                        )
                    )
                    .tag(2)

                    OnboardingBudgetView(
                        budgetText: Binding(
                            get: { controller.formatted(controller.profile.monthlyBudget) },
                            set: { controller.setBudget(from: $0) }
                        ),
                        income: controller.profile.monthlyIncome
                    )
                    .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: controller.currentStep)

                // Next / Finish button
                nextButton
                    .padding(.horizontal, 24)
                    .padding(.bottom, 36)
            }
        }
    }

    // MARK: - Header

    private var headerBar: some View {
        HStack(spacing: 12) {
            // Back button
            Button {
                withAnimation { controller.goBack() }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(controller.isFirstStep ? .clear : AppTheme.textPrimary)
            }
            .disabled(controller.isFirstStep)

            // Progress bar
            HStack(spacing: 6) {
                ForEach(0..<controller.totalSteps, id: \.self) { index in
                    Capsule()
                        .fill(index <= controller.currentStep ? AppTheme.teal : AppTheme.teal.opacity(0.2))
                        .frame(height: 4)
                        .animation(.easeInOut, value: controller.currentStep)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    // MARK: - Next Button

    private var nextButton: some View {
        Button {
            #if canImport(UIKit)
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            #endif
            withAnimation {
                if controller.isLastStep {
                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                    onFinished(controller.profile)
                } else {
                    controller.goNext()
                }
            }
        } label: {
            Text(controller.isLastStep ? "Let's go! 🚀" : "Continue")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    Group {
                        if controller.canProceed {
                            AnyView(AppTheme.tealGradientHorizontal)
                        } else {
                            AnyView(Color.gray.opacity(0.3))
                        }
                    }
                )
                .cornerRadius(14)
        }
        .disabled(!controller.canProceed)
    }
}
