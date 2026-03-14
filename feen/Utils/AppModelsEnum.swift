//
//  AppModelsEnum.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 12/03/26.
//

import Foundation
import SwiftData

/// Untuk mendefinisikan Model yang ingin disimpan melalui SwiftData (Optional)
enum AppModelsEnum {
    static let all: [any PersistentModel.Type] = [
        BudgetModel.self,
        HistoryModel.self
    ]
}
