import SwiftUI

struct AddExpenseView: View {
    @ObservedObject var expenseController: ExpenseController
    @ObservedObject var categoryController: CategoryController
    @Environment(\.dismiss) var dismiss

    // State
    @State private var amountString: String = "0"
    @State private var selectedDate: Date = Date()
    @State private var selectedCategory: Category? = nil
    @State private var description: String = ""
    @State private var showDatePicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var transactionType: TransactionType = .expense

    var amountValue: Int { Int(amountString) ?? 0 }

    var body: some View {
        VStack(spacing: 0) {

            // MARK: Header
            Text("Insert Transaction")
                .font(.headline)
                .padding()

            ScrollView {
                VStack(spacing: 16) {

                    // MARK: Amount Display
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Amount")
                            .font(.caption).foregroundColor(.secondary)
                        Text("Rp \(formattedAmount)")
                            .font(.largeTitle.bold())
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    // Ganti HStack Date & Category Row menjadi:
                    HStack(spacing: 12) {
                        // Tombol Date
                        Button(action: { showDatePicker.toggle() }) {
                            Label(formattedDate, systemImage: "calendar")
                                .font(.subheadline)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                        .foregroundColor(.primary)
                        .sheet(isPresented: $showDatePicker) {
                            DatePickerSheet(selectedDate: $selectedDate)
                        }

                        Spacer()

                        // Tombol Pengeluaran / Pemasukan
                        HStack(spacing: 0) {
                            ForEach(TransactionType.allCases, id: \.self) { type in
                                Button(action: {
                                    transactionType = type
                                    selectedCategory = nil  // reset kategori saat ganti tipe
                                }) {
                                    Text(type.rawValue)
                                        .font(.caption.bold())
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(transactionType == type ? typeColor(type) : Color(.systemGray6))
                                        .foregroundColor(transactionType == type ? .white : .secondary)
                                }
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.horizontal)

                    // MARK: Category Picker
                    CategoryPickerView(
                        categoryController: categoryController,
                        selectedCategory: $selectedCategory,
                        transactionType: transactionType
                    )
                    
                    .padding(.horizontal)

                    // MARK: Description
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Description")
                            .font(.caption).foregroundColor(.secondary)
                        TextEditor(text: $description)
                            .frame(height: 80)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    // MARK: Submit
                    Button(action: submitExpense) {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                amountValue > 0
                                ? LinearGradient(colors: [Color(red: 0.0,  green: 0.55, blue: 0.50), Color(red: 0.0,  green: 0.33, blue: 0.30)], startPoint: .leading, endPoint: .trailing)
                                : LinearGradient(colors: [Color.gray, Color.gray], startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(12)
                    }
                    .disabled(amountValue == 0)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }

            Divider()

            // MARK: Numpad
            NumpadView(displayValue: $amountString)
                .padding(.vertical)
                .background(Color(.systemBackground))
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK") {}
        } message: {
            Text(alertMessage)
        }
    }

    // MARK: - Helpers
    private var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: amountValue)) ?? amountString
    }

    private var formattedDate: String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.locale = Locale(identifier: "en_EN")
        return f.string(from: selectedDate)
    }

    private func submitExpense() {
        guard amountValue > 0 else {
            alertMessage = "Jumlah tidak boleh kosong"
            showAlert = true
            return
        }
        guard let category = selectedCategory else {
            alertMessage = "Pilih kategori terlebih dahulu"
            showAlert = true
            return
        }

        expenseController.addExpense(
            amount: amountValue,
            date: selectedDate,
            category: category,
            description: description
        )
        dismiss()
    }
    
    private func typeColor(_ type: TransactionType) -> Color {
        type == .expense ? .red : .green
    }
}

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            DatePicker("Pilih Tanggal", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
                .navigationBarItems(trailing: Button("Selesai") { dismiss() })
        }
    }
}


#Preview {
    // Simple preview/mocks for controllers
    let expenseController = ExpenseController()
    let categoryController = CategoryController()
    return AddExpenseView(
        expenseController: expenseController,
        categoryController: categoryController
    )
}
