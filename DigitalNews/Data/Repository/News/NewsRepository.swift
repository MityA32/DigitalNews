//
//  NewsRepository.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 10.10.2023.
//

import Foundation

final class NewsRepository {
    
    private let coredataService: CoreDataServiceProtocol
    private let networkService: AlamoNetworkingProtocol
    
    private(set) var savedNews: [PieceOfNews]
    
    init(
        coredataService: CoreDataServiceProtocol = CoreDataService(),
        networkService: AlamoNetworkingProtocol = AlamoNetworking("https://newsapi.org")
    ) {
        self.coredataService = coredataService
        self.networkService = networkService
        savedNews = coredataService.fetch(PieceOfNews.self)
    }

    func getPortion(
        topic: String,
        sortBy: String = "publishedAt",
        from startDate: Date? = nil,
        to endDate: Date? = nil,
        pageNumber: Int,
        completion: @escaping (Result<[PieceOfNewsModel], Error>) -> Void
    ) {
        networkService.perform(
            .get,
            NewsEndpoint.everything,
            GetNewsInstruction(q: topic, sortBy: sortBy, page: "\(pageNumber)"),
            of: NewsModel.self
        ) { result in
            switch result {
            case .success(let data):
                if let articles = data?.articles {
                    
                    completion(.success(articles.filter { $0.title != "[Removed]" }))
                } else {
                    completion(.success([]))
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func save(_ newPieceOfNews: PieceOfNews) {
        coredataService.write {
//            newPieceOfNews
//            let pieceOfNews = coredataService.create(PieceOfNews.self) { pieceOfNews in
//
//                pieceOfNews.title = newPieceOfNews.title
//                pieceOfNews.publishedAt = newPieceOfNews.publishedAt
//                pieceOfNews.author = newPieceOfNews.author
//                pieceOfNews.source = newPieceOfNews.source
//                pieceOfNews.newsDescription = newPieceOfNews.description
//                pieceOfNews.url = newPieceOfNews.url
//                pieceOfNews.urlToImage = newPieceOfNews.urlToImage
//
//            }
            savedNews.append(newPieceOfNews)
        }
    }
    
    func delete(_ pieceOfNews: PieceOfNews) {
        coredataService.delete(pieceOfNews)
        if let index = savedNews.firstIndex(of: pieceOfNews) {
            savedNews.remove(at: index)
        }
    }
}

private extension NewsRepository {
    
    func parsedArticles(from articles: [PieceOfNewsModel]) -> [PieceOfNews] {
        articles.map { unparsedArticle in
            coredataService.create(PieceOfNews.self) { article in
                
                article.title = unparsedArticle.title
                article.publishedAt = unparsedArticle.publishedAt?.formattedFromISO8601()
                article.author = unparsedArticle.author
                article.source = unparsedArticle.source?.name
                article.newsDescription = unparsedArticle.description
                
                article.url = URL(string: unparsedArticle.url ?? "")
                article.urlToImage = URL(string: unparsedArticle.urlToImage ?? "")

            }
        }
    }
    
}
