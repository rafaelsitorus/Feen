//
//  DictionaryModel.swift
//  Feen
//
//  Created by Made Vidyatma Adhi Krisna on 11/03/26.
//

import Foundation

struct Dictionaries: Identifiable, Codable {
    let id = UUID()
    let title: String
    let definition: String
}
