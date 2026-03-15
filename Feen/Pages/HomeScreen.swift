import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var settingController: SettingsController
    @EnvironmentObject var budgetController: BudgetController
    @EnvironmentObject var historyController: HistoryController

    @State private var quoteMessage: String = "Loading your financial insight..."  // ← MISSING
    @State private var isLoadingQuote: Bool = false                                // ← MISSING

    private func fetchQuote() async {
        guard !isLoadingQuote else { return }
        isLoadingQuote = true
        do {
            quoteMessage = try await GeminiService.shared.generateHomeQuote(
                monthlyIncome: settingController.profile.monthlyIncome ?? 0,
                monthlyBudget: settingController.profile.monthlyBudget ?? 0,
                earned: budgetController.earned,
                spent: budgetController.spent
            )
        } catch {
            quoteMessage = "Keep tracking your spending — every rupiah counts!"
        }
        isLoadingQuote = false
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hi, \(settingController.displayName)!")
                .font(Font.title3.bold())
                .padding(.leading, 4)

            BudgetSummaryComponent(
                todayDate: Date.now.formatted(
                    .dateTime.weekday(.wide).day().month(.wide).year()),
                earned: budgetController.earned,
                spent: budgetController.spent
            )

            QuoteComponent(
                quoteMessage: quoteMessage,
                isLoading: isLoadingQuote,
                onRefresh: { Task { await fetchQuote() } }
            )
            
            HistoryComponents(historyRecords: historyController.histories, isHome: true)

            Spacer()
        }
        .padding(.horizontal, 24)
        .task {                                          // ← MISSING: trigger fetch saat screen muncul
            await fetchQuote()
        }
        .onChange(of: budgetController.spent) { _ in    // ← MISSING: refresh kalau ada transaksi baru
            Task { await fetchQuote() }
        }
        .onChange(of: budgetController.earned) { _ in   // ← MISSING
            Task { await fetchQuote() }
        }
    }
}
