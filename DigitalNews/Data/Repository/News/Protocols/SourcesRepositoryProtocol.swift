//
//  SourcesRepositoryProtocol.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 11.10.2023.
//

import Foundation

protocol SourcesRepositoryProtocol {
    func getSources(category: String, country: String, completion: @escaping (Result<[NewsSource], Error>) -> Void)
}
