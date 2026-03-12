//
//  CategoryController.swift
//  Feen
//
//  Created by Juan Fausta Pringadi on 11/03/26.
//

import Foundation
import Combine

class CategoryController: ObservableObject {
    @Published var categories: [Category] = []

    init() {
        categories = LocalStorageManager.shared.loadCategories()
    }
    
    func categories(for type: TransactionType) -> [Category] {
        categories.filter{
            $0.type == type
        }
    }
    
    func addCustomCategory(name: String, icon: String = "tag.fill", type: TransactionType) {
        let newCat = Category(name: name, icon: icon, type: type, isCustom: true)
        categories.append(newCat)
        LocalStorageManager.shared.saveCategories(categories)
    }
}
