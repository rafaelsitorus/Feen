//
//  NewsModel.swift
//  Feen
//
//  Created by Made Vidyatma Adhi Krisna on 11/03/26.
//

import Foundation

struct ProcessedNews: Identifiable {
    let id = UUID()
    var urlToImage: String?
    var publishedAt: String
    var catchyTitle: String
    var summary: String
}
