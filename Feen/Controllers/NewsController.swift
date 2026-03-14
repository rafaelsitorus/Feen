//
//  NewsController.swift
//  Feen
//
//  Created by Made Vidyatma Adhi Krisna on 11/03/26.
//

import Foundation
import Combine

@MainActor
class NewsController: ObservableObject {
    @Published var isLoading = false
    @Published var processedNews: [ProcessedNews] = []

    func fetchAndProcess() async {
        // TODO: fetch financial news and process with AI
    }
}
