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
    
    var favouriteNews: [PieceOfNews] { newsRepository.favouriteNews }
    
    init(newsRepository: NewsRepository) {
        self.newsRepository = newsRepository
    }
    
    func loadMore(for topic: String = "popular", completion: @escaping (Result<[PieceOfNewsModel], Error>) -> Void) {
        if topic != currentTopic {
            currentPageNumber = 0
        }
        let sources = selectedSources.isEmpty ? "" : selectedSources.map { $0.id }.joined(separator: ", ")
        let topic = sources.isEmpty ? topic : ""
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
    
}
