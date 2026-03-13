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
                        Label("Tambah", systemImage: "plus")
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray5))
                            .cornerRadius(20)
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

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: category.icon)
            Text(category.name)
        }
        .font(.caption)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isSelected ? Color.accentColor : Color(.systemGray5))
        .foregroundColor(isSelected ? .white : .primary)
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

#Preview {
    CategoryPickerView(
        categoryController: CategoryController(),
        selectedCategory: .constant(nil),
        transactionType: .expense
    )
}
