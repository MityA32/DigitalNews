//
//  Fetcher.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 10.10.2023.
//

import Foundation

protocol Fetcher {
    func fetchData<T: Decodable>(of type: T.Type, with url: URL, completion: @escaping (Result<T, Error>) -> Void)
}
