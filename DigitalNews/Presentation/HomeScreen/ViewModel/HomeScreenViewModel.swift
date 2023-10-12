//
//  HomeScreenViewModel.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 03.10.2023.
//

import Foundation

final class HomeScreenViewModel {
    
    private let newsRepository: NewsRepository
    
    private(set) var news = [PieceOfNewsModel]()
    
    var currentTopic = "popular"
    var currentPageNumber = 0
    var selectedCategory: NewsCategory = .any
    var selectedCountry: NewsCountry = .any
    var selectedSources: [NewsSource] = []
    var sources: [NewsSource] = []
    
    var favouriteNews: [PieceOfNews] { newsRepository.favouriteNews }
    
    init(newsRepository: NewsRepository) {
        self.newsRepository = newsRepository
    }
    
    func loadMore(for topic: String = "popular", completion: @escaping (Result<[PieceOfNewsModel], Error>) -> Void) {
        let sources = if !selectedSources.isEmpty {
            selectedSources.map(\.id).joined(separator: ", ")
        } else {
            sources.map(\.id).joined(separator: ", ")
        }
        let topic = if sources.isEmpty && selectedSources.isEmpty { 
            currentTopic.isEmpty ? "popular" : currentTopic
        } else {
            currentTopic == "popular" ? "" : currentTopic
        }
        newsRepository.getEverythingPortion(topic: topic, sources: sources, pageNumber: currentPageNumber + 1) { [weak self] in
            guard let self else { return }
            switch $0 {
            case .success(let data):
                if currentPageNumber == 0 {
                    news = data
                } else {
                    news.append(contentsOf: data)
                }
                
                currentTopic = topic
                currentPageNumber += 1
                
                completion(.success(news))
            case .failure(let error):
                print("loadMore: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func refreshNews(completion: @escaping (Result<[PieceOfNewsModel], Error>) -> Void) {
        currentPageNumber = 0
        loadMore(for: currentTopic, completion: completion)
    }
    
    func save(_ pieceOfNews: PieceOfNewsModel) {
        newsRepository.save(pieceOfNews)
        if let index = news.firstIndex(where: { $0 == pieceOfNews }) {
            news[index].isFavourite = true
        }
    }
    
    func remove(_ pieceOfNews: PieceOfNewsModel) {
        newsRepository.remove(pieceOfNews)
        if let index = news.firstIndex(where: { $0 == pieceOfNews }) {
            news[index].isFavourite = false
        }
    }
    
    func remove(_ pieceOfNews: PieceOfNews) {
        if let index = news.firstIndex(where: {
            $0.title == pieceOfNews.title &&
            $0.publishedAt?.formattedFromISO8601() == pieceOfNews.publishedAt &&
            URL(string: $0.url ?? "") == pieceOfNews.url &&
            $0.source?.name == pieceOfNews.source
        }) {
            news[index].isFavourite = false
        }
        newsRepository.remove(pieceOfNews)
    }
    
}
