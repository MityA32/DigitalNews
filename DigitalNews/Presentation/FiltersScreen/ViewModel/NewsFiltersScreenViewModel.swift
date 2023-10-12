//
//  NewsFiltersScreenViewModel.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 11.10.2023.
//

import Foundation

final class NewsFiltersScreenViewModel {
    
    let sourcesRepository: SourcesRepository
    
    let categories = NewsCategory.allCases
    let countries = NewsCountry.allCases
    var sources: [NewsSource] = []
    
    var selectedCategory: NewsCategory?
    var selectedCountry: NewsCountry?
    var selectedSources: [NewsSource] = []
    
    init(sourcesRepository: SourcesRepository) {
        self.sourcesRepository = sourcesRepository
    }
    
    func getSources(completion: @escaping (Result<[NewsSource], Error>) -> Void) {

        sourcesRepository
            .getSources(
                category: selectedCategory?.rawValue ?? "",
                country: selectedCountry?.rawValue ?? ""
            ) { [weak self] result in
                guard let self else { return }
                switch result {
                    case .success(let sources):
                        self.sources = sources

                        completion(.success(self.sources))
                    case .failure(let error):
                        completion(.failure(error))
            }
        }
        
    }
    
}
