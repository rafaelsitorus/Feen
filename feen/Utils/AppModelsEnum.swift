//
//  AppModelsEnum.swift
//  feen
//
//  Created by Fidel Fausta Cavell on 12/03/26.
//

import Foundation
import SwiftData

enum AppModelsEnum {
    static let all: [any PersistentModel.Type] = [
        BudgetModel.self,
        HistoryModel.self,
        UserModel.self
    ]
}
