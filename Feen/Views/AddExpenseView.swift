import SwiftUI

struct AddExpenseView: View {
    
    // Tambah di atas struct AddExpenseView
    private enum FocusField {
        case description
    }
    
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
    
    // Numpad & keyboard control
    @State private var isAmountFocused: Bool = false
    //    @FocusState private var isDescriptionFocused: Bool
    @FocusState private var focusedField: FocusField?
    
    // Camera
    @State private var showCameraOptions = false
    @State private var showCamera = false
    @State private var showImagePicker = false
    @State private var capturedImage: UIImage? = nil
    
    var amountValue: Int { Int(amountString) ?? 0 }
    
    // Pre-defined gradients to help the compiler
    private let expenseGradient = LinearGradient(
        colors: [Color(red: 0.75, green: 0.10, blue: 0.10),
                 Color(red: 0.50, green: 0.05, blue: 0.05)],
        startPoint: .leading, endPoint: .trailing)
    
    private let incomeGradient = LinearGradient(
        colors: [Color(red: 0.0, green: 0.55, blue: 0.50),
                 Color(red: 0.0, green: 0.33, blue: 0.30)],
        startPoint: .leading, endPoint: .trailing)
    
    private let inactiveGradient = LinearGradient(
        colors: [Color(.systemGray6), Color(.systemGray6)],
        startPoint: .leading, endPoint: .trailing)
    
    private let saveGradient = LinearGradient(
        colors: [Color(red: 0.0, green: 0.55, blue: 0.50),
                 Color(red: 0.0, green: 0.33, blue: 0.30)],
        startPoint: .leading, endPoint: .trailing)
    
    private let disabledGradient = LinearGradient(
        colors: [Color.gray, Color.gray],
        startPoint: .leading, endPoint: .trailing)
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: Header
            Text("Insert Transaction")
                .font(.headline)
                .padding()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: Amount Display — tap to show numpad
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Amount")
                            .font(.caption).foregroundColor(.secondary)
                        Button(action: {
                            focusedField = nil
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                isAmountFocused = true
                            }
                        }) {
                            HStack {
                                Spacer()
                                Text("Rp \(formattedAmount)")
                                    .font(.largeTitle.bold())
                                    .foregroundColor(.primary)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(isAmountFocused ? Color.accentColor : Color.clear, lineWidth: 2)
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)
                    
                    // MARK: Date & Transaction Type Row
                    HStack(spacing: 12) {
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
                        
                        HStack(spacing: 0) {
                            ForEach(TransactionType.allCases, id: \.self) { type in
                                let isActive = transactionType == type
                                Button(action: {
                                    transactionType = type
                                    selectedCategory = nil
                                }) {
                                    Text(type.rawValue)
                                        .font(.caption.bold())
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(
                                            Group {
                                                if isActive {
                                                    typeColor(type)
                                                } else {
                                                    inactiveGradient
                                                }
                                            }
                                        )
                                        .foregroundColor(isActive ? .white : .secondary)
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
                    
                    // MARK: Description — compact, keyboard on tap
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Description")
                            .font(.caption).foregroundColor(.secondary)
                        TextField("Add a note (optional)…", text: $description, axis: .vertical)
                            .lineLimit(2...3)
                            .focused($focusedField, equals: .description)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Done") {
                                        focusedField = nil
                                    }
                                }
                            }
                            .onTapGesture {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                    isAmountFocused = false
                                }
                                focusedField = .description
                            }
                    }
                    .padding(.horizontal)
                    
                    // MARK: Camera Button
                    Button(action: {
                        isAmountFocused = false
                        focusedField = nil
                        showCameraOptions = true
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: capturedImage != nil ? "checkmark.circle.fill" : "camera.fill")
                                .font(.system(size: 16, weight: .semibold))
                            Text(capturedImage != nil ? "Photo Attached" : "Scan Receipt")
                                .font(.subheadline.weight(.semibold))
                        }
                        .foregroundStyle(
                            capturedImage != nil
                            ? AnyShapeStyle(Color.white)
                            : AnyShapeStyle(LinearGradient(
                                colors: [Color(red: 0.0, green: 0.55, blue: 0.50),
                                         Color(red: 0.0, green: 0.33, blue: 0.30)],
                                startPoint: .leading, endPoint: .trailing))
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(capturedImage != nil ? Color.accentColor : Color(.systemGray6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(capturedImage != nil ? AnyShapeStyle(Color.clear) : AnyShapeStyle(LinearGradient(
                                    colors: [Color(red: 0.0, green: 0.55, blue: 0.50),
                                             Color(red: 0.0, green: 0.33, blue: 0.30)],
                                    startPoint: .leading, endPoint: .trailing)), lineWidth: 1.5)
                        )
                    }
                    .padding(.horizontal)
                    .confirmationDialog("Add Receipt Photo", isPresented: $showCameraOptions, titleVisibility: .visible) {
                        Button("Take Photo") { showCamera = true }
                        Button("Choose from Library") { showImagePicker = true }
                        if capturedImage != nil {
                            Button("Remove Photo", role: .destructive) { capturedImage = nil }
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                    .sheet(isPresented: $showCamera) {
                        CameraPickerView(image: $capturedImage, sourceType: .camera)
                    }
                    .sheet(isPresented: $showImagePicker) {
                        CameraPickerView(image: $capturedImage, sourceType: .photoLibrary)
                    }
                    
                    // MARK: Submit
                    Button(action: submitExpense) {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(amountValue > 0 ? saveGradient : disabledGradient)
                            .cornerRadius(12)
                    }
                    .disabled(amountValue == 0)
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                }
                .padding(.vertical)
            }
            .onTapGesture {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    isAmountFocused = false
                }
                focusedField = nil
            }
            
            // MARK: Numpad — slides up when amount is focused
            if isAmountFocused {
                Divider()
                NumpadView(displayValue: $amountString, onDismiss: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        isAmountFocused = false
                    }
                })
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .background(Color(.systemBackground))
            }
        }
        .padding(.horizontal, 12)
        .alert("Error", isPresented: $showAlert) {
            Button("OK") {}
        } message: {
            Text(alertMessage)
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: isAmountFocused)
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
    
    private func typeColor(_ type: TransactionType) -> LinearGradient {
        type == .expense ? expenseGradient : incomeGradient
    }
}

// MARK: - Camera / Image Picker Bridge

struct CameraPickerView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPickerView
        init(_ parent: CameraPickerView) { self.parent = parent }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            parent.image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

// MARK: - Date Picker Sheet

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {                          // ← was NavigationView
            DatePicker("Pilih Tanggal", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {   // ← ganti dari navigationBarItems
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}

#Preview {
    let expenseController = ExpenseController()
    let categoryController = CategoryController()
    return AddExpenseView(
        expenseController: expenseController,
        categoryController: categoryController
    )
}
