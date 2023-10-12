//
//  NewsRepositoryProtocol.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 11.10.2023.
//

import Foundation

protocol NewsRepositoryProtocol {
    
    var favouriteNews: [PieceOfNews] { get }
    func getEverythingPortion(
        topic: String,
        sources: String,
        from startDate: Date?,
        to endDate: Date?,
        sortBy: String,
        pageNumber: Int,
        completion: @escaping (Result<[PieceOfNewsModel], Error>) -> Void
    )
    
}
