//
//  SourcesRepository.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 11.10.2023.
//

import Foundation

final class SourcesRepository: SourcesRepositoryProtocol {
    
    private let networkService: AlamoNetworkingProtocol
    
    init(networkService: AlamoNetworkingProtocol = AlamoNetworking("https://newsapi.org", headers: NewsApi.headers)) {
        self.networkService = networkService
    }
    
    func getSources(category: String, country: String, completion: @escaping (Result<[NewsSource], Error>) -> Void) {
        networkService.perform(
            .get,
            NewsEndpoint.sources,
            GetSourcesInstruction(category: category, country: country),
            of: SourcesModel.self
        ) { result in
            switch result {
                case .success(let data):
                    if let sources = data?.sources {
                        let withoutrusia = sources.filter {
                            !$0.id.contains("lenta") ||
                            !$0.id.contains("google-news-ru") ||
                            !$0.id.contains("rbc") ||
                            !$0.id.contains("rt")
                        }
                        completion(.success(withoutrusia))
                    } else {
                        completion(.success([]))
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
