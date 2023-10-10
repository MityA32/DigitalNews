//
//  NewsRepository.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 10.10.2023.
//

import Foundation

final class NewsRepository {
    
    let coredataService: CoreDataServiceProtocol
    let networkService: AlamoNetworkingProtocol
    
    init(
        coredataService: CoreDataServiceProtocol = CoreDataService(),
        networkService: AlamoNetworkingProtocol = AlamoNetworking("https://newsapi.org")
    ) {
        self.coredataService = coredataService
        self.networkService = networkService
    }

    func getPortion(
        topic: String,
        from startDate: Date? = nil,
        to endDate: Date? = nil,
        pageNumber: Int,
        completion: @escaping (Result<NewsModel, Error>) -> Void
    ) {
        networkService.perform(
            .get,
            NewsEndpoint.everything,
            GetNewsInstruction(q: topic, page: "\(pageNumber)"),
            of: NewsModel.self
        ) { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
}
