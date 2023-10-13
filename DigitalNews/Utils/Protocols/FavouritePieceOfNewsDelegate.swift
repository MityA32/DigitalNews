//
//  MarkFavouritePieceOfNewsDelegate.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 12.10.2023.
//

import Foundation

protocol AddFavouritePieceOfNewsDelegate: NSObject {
    func addFavourite(_ pieceOfNews: PieceOfNewsModel)
}

protocol RemoveFavouritePieceOfNewsDelegate: NSObject {
    func removeFavourite(_ pieceOfNews: PieceOfNewsModel)
}
