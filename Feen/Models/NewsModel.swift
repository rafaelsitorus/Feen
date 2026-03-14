//
//  NewsModel.swift
//  Feen
//
//  Created by Juan Fausta Pringadi on 14/03/26.
//

import Foundation

struct NewsModel: Identifiable, Decodable{
    let id = UUID()
    let title: String
    let urlToImage: String?
    let content: String?
    let publishedAt: String
    
    enum CodingKeys: String, CodingKey{
        case title, urlToImage, content, publishedAt
    }
}
