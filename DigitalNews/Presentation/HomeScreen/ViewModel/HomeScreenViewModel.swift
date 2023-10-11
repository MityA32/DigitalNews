//
//  HomeScreenViewModel.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 03.10.2023.
//

import Foundation

final class HomeScreenViewModel {
    
    enum NewsListType {
        case latest
        case saved
    }
    
    private let newsRepository: NewsRepository
    
    private(set) var news = [PieceOfNewsModel]()
    
    var currentNewsListType: NewsListType = .latest
    var currentTopic = "popular"
    var currentPageNumber = 0
    
    var savedNews: [PieceOfNews] { newsRepository.savedNews }
    
    init(newsRepository: NewsRepository) {
        self.newsRepository = newsRepository
    }
    
    func loadMore(for topic: String, completion: @escaping (Result<[PieceOfNewsModel], Error>) -> Void) {
        if topic != currentTopic {
            currentPageNumber = 0
        }
        newsRepository.getPortion(topic: topic, pageNumber: currentPageNumber + 1) { [weak self] in
            switch $0 {
            case .success(let data):
                self?.news.append(contentsOf: data)
                
                self?.currentTopic = topic
                self?.currentPageNumber += 1
                
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
