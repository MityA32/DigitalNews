//
//  NewsRepository.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 10.10.2023.
//

import Foundation

final class NewsRepository: NewsRepositoryProtocol {
    
    private let coredataService: CoreDataServiceProtocol
    private let networkService: AlamoNetworkingProtocol
    
    private(set) var favouriteNews: [PieceOfNews]
    
    init(
        coredataService: CoreDataServiceProtocol = CoreDataService(),
        networkService: AlamoNetworkingProtocol = AlamoNetworking("https://newsapi.org", headers: NewsApi.headers)
    ) {
        self.coredataService = coredataService
        self.networkService = networkService
        favouriteNews = coredataService.fetch(PieceOfNews.self)
    }

    func getEverythingPortion(
        topic: String,
        sources: String = "",
        from startDate: Date? = nil,
        to endDate: Date? = nil,
        sortBy: String = "publishedAt",
        pageNumber: Int,
        completion: @escaping (Result<[PieceOfNewsModel], Error>) -> Void
    ) {
        networkService.perform(
            .get,
            NewsEndpoint.everything,
            GetNewsInstruction(q: topic, sources: sources, sortBy: sortBy, page: "\(pageNumber)"),
            of: NewsModel.self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                if let articles = data?.articles {
                    favouriteNews = coredataService.fetch(PieceOfNews.self)
                    
                    completion(.success(articles.filter { $0.title != "[Removed]" }))
                } else {
                    completion(.success([]))
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func save(_ newPieceOfNews: PieceOfNewsModel) {
        coredataService.write {
            let pieceOfNews = coredataService.create(PieceOfNews.self) { pieceOfNews in

                pieceOfNews.title = newPieceOfNews.title
                pieceOfNews.publishedAt = newPieceOfNews.publishedAt?.formattedFromISO8601()
                pieceOfNews.author = newPieceOfNews.author
                pieceOfNews.source = newPieceOfNews.source?.name
                pieceOfNews.newsDescription = newPieceOfNews.description
                pieceOfNews.url = URL(string: newPieceOfNews.url ?? "")
                pieceOfNews.urlToImage = URL(string: newPieceOfNews.urlToImage ?? "")

            }
            favouriteNews.append(pieceOfNews)
        }
    }
    
    func delete(_ pieceOfNews: PieceOfNews) {
        coredataService.delete(pieceOfNews)
        if let index = favouriteNews.firstIndex(of: pieceOfNews) {
            favouriteNews.remove(at: index)
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
