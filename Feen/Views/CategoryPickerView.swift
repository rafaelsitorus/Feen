import SwiftUI

struct CategoryPickerView: View {
    @ObservedObject var categoryController: CategoryController
    @Binding var selectedCategory: Category?
    var transactionType: TransactionType                    // tambah ini
    @State private var showAddCategory = false
    @State private var newCategoryName = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Category")
                .font(.caption)
                .foregroundColor(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(categoryController.categories(for: transactionType)) { category in
                        CategoryChip(
                            category: category,
                            isSelected: selectedCategory?.id == category.id
                        )
                        .onTapGesture { selectedCategory = category }
                    }

                    Button(action: { showAddCategory = true }) {
                        Label("Add", systemImage: "plus")
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray5))
                            .cornerRadius(20)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(red: 0.0, green: 0.55, blue: 0.50),
                                             Color(red: 0.0, green: 0.33, blue: 0.30)],
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )
                    }
                }
                .padding(.horizontal, 2)
            }
        }
        .sheet(isPresented: $showAddCategory) {
            AddCategorySheet(name: $newCategoryName) {
                if !newCategoryName.isEmpty {
                    categoryController.addCustomCategory(
                        name: newCategoryName,
                        type: transactionType               // tambah ini
                    )
                    newCategoryName = ""
                }
                showAddCategory = false
            }
        }
    }
}

struct CategoryChip: View {
    let category: Category
    let isSelected: Bool

    private let gradient = LinearGradient(
        colors: [Color(red: 0.0, green: 0.55, blue: 0.50),
                 Color(red: 0.0, green: 0.33, blue: 0.30)],
        startPoint: .leading, endPoint: .trailing
    )

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: category.icon)
            Text(category.name)
        }
        .font(.caption)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            isSelected ? gradient : LinearGradient(colors: [Color(.systemGray5), Color(.systemGray5)], startPoint: .leading, endPoint: .trailing)
        )
        .foregroundStyle(isSelected ? Color.white : Color.black)
        .cornerRadius(20)
    }
}

struct AddCategorySheet: View {
    @Binding var name: String
    var onSave: () -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("Nama kategori baru", text: $name)
            }
            .navigationTitle("Tambah Kategori")
            .navigationBarItems(
                leading: Button("Batal") {
                    name = ""           // reset name saat batal
                    onSave()
                },
                trailing: Button("Simpan") { onSave() }
            )
        }
    }
}

private extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, @ViewBuilder then: (Self) -> Content, else elseTransform: (Self) -> Content) -> some View {
        if condition {
            then(self)
        } else {
            elseTransform(self)
        }
    }
}

#Preview {
    CategoryPickerView(
        categoryController: CategoryController(),
        selectedCategory: .constant(nil),
        transactionType: .expense
    )
}
