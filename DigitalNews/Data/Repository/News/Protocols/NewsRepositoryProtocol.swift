//
//  NewsRepositoryProtocol.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 11.10.2023.
//

import Foundation

protocol NewsRepositoryProtocol {
    
    var savedNews: [PieceOfNews] { get }
    func getPortion(
        topic: String,
        from startDate: Date?,
        to endDate: Date?,
        pageNumber: Int,
        completion: @escaping (Result<[PieceOfNews], Error>) -> Void
    )
    
}
