//
//  NewsRepository.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 10.10.2023.
//

import Foundation
import OrderedCollections

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
                    let news = articles
                        .filter { $0.title != "[Removed]" }
                        .map { originalPieceOfNews in
                            var newPieceOfNews = originalPieceOfNews
                            if self.favouriteNews.first(where: {
                                $0.title == newPieceOfNews.title &&
                                $0.publishedAt == newPieceOfNews.publishedAt?.formattedFromISO8601() &&
                                $0.url == URL(string: newPieceOfNews.url ?? "") &&
                                $0.source == newPieceOfNews.source?.name &&
                                $0.newsDescription == newPieceOfNews.description
                            }) != nil {
                                newPieceOfNews.isFavourite = true
                            } else {
                                newPieceOfNews.isFavourite = false
                            }
                            return newPieceOfNews
                        }
                    
                    completion(.success(Array(OrderedSet(news))))
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
    
    func remove(_ pieceOfNews: PieceOfNewsModel) {
        if let favouritePieceOfNews = coredataService.fetch(PieceOfNews.self).first(where: {
            $0.title == pieceOfNews.title &&
            $0.publishedAt == pieceOfNews.publishedAt?.formattedFromISO8601() &&
            $0.url == URL(string: pieceOfNews.url ?? "") &&
            $0.source == pieceOfNews.source?.name
        }) {
            coredataService.write {
                coredataService.remove(favouritePieceOfNews)
            }
            favouriteNews = coredataService.fetch(PieceOfNews.self)
        }
    }
    
    func remove(_ pieceOfNews: PieceOfNews) {
        coredataService.write {
            coredataService.remove(pieceOfNews)
        }
        favouriteNews = coredataService.fetch(PieceOfNews.self)
    }
}
