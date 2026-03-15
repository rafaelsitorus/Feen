import SwiftUI

struct ContentView: View {
    @EnvironmentObject var expenseController: ExpenseController
    @EnvironmentObject var categoryController: CategoryController
    @EnvironmentObject var settingsController: SettingsController

    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    @State private var selectedTab = 0
    @State private var showAddExpense = false

    var body: some View {
        // Routing onboarding vs main app
        if !hasCompletedOnboarding || !settingsController.profile.isComplete {
            
            OnboardingContainerView { completedProfile in
                settingsController.profile = completedProfile
                hasCompletedOnboarding = true
            }
        } else {
            mainTabView
        }
    }

    private var mainTabView: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                NavigationStack { HomeScreen() }.tag(0)
                NavigationStack { NewsScreen() }.tag(1)
                NavigationStack { AddExpenseView(expenseController: expenseController,
                                                 categoryController: categoryController) }.tag(2)
                NavigationStack { DictionaryScreen(dicts: dictsData) }.tag(3)
                NavigationStack { SettingsView() }.tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            GlassTabBar(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ExpenseController())
        .environmentObject(CategoryController())
        .environmentObject(SettingsController())
}
