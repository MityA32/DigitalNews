//
//  FavouriteNewsScreenDelegate.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 12.10.2023.
//

import Foundation


protocol FavouriteNewsScreenDelegate: NSObject {
    func remove(_ pieceOfNews: PieceOfNews)
}
