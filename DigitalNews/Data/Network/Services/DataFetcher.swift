//
//  DataFetcher.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 10.10.2023.
//
 
import Foundation
import Alamofire

final class DataFetcher: Fetcher {

    func fetchData<T: Decodable>(of type: T.Type, with url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url).responseDecodable(of: T.self, completionHandler: { response in
            switch response.result {
                case .success(let decodedResponse):
                    completion(.success(decodedResponse))
                case .failure(let error):
                    completion(.failure(error))
            }
        })
    }

}
