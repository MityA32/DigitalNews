//
//  News+Decodable.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 10.10.2023.
//

import Foundation

struct NewsModel: Decodable {
    let articles: [PieceOfNewsModel]
}

struct PieceOfNewsModel: Decodable, Identifiable {
    let id = UUID()
    let source: SourceModel?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    
    private enum CodingKeys: CodingKey {
        case source
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
    }
}


struct SourceModel: Decodable {
    let name: String?
}
