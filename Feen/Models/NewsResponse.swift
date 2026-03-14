//
//  NewsResponse.swift
//  Feen
//
//  Created by Juan Fausta Pringadi on 14/03/26.
//

struct NewsResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [NewsModel]
}
