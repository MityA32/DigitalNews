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

struct ID<T>: Equatable {
    private let value = UUID()
}

struct PieceOfNewsModel: Decodable, Equatable {
    
    let id = ID<Self>()
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
    
    static func ==(lhs: PieceOfNewsModel, rhs: PieceOfNewsModel) -> Bool {
        return lhs.source == rhs.source &&
               lhs.author == rhs.author &&
               lhs.title == rhs.title &&
               lhs.description == rhs.description &&
               lhs.url == rhs.url &&
               lhs.urlToImage == rhs.urlToImage &&
               lhs.publishedAt == rhs.publishedAt
    }
    
}

struct SourceModel: Decodable, Equatable {
    let name: String?
}
