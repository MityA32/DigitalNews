//
//  HomeScreenViewModel.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 03.10.2023.
//

import Foundation

final class HomeScreenViewModel {
    let newsRepository: NewsRepository
    
    init(newsRepository: NewsRepository) {
        self.newsRepository = newsRepository
        newsRepository.getPortion(topic: "popular", pageNumber: 1) {
            switch $0 {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
