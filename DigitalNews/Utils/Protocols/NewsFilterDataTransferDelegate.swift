//
//  NewsFilterDataTransferDelegate.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 12.10.2023.
//

import Foundation

protocol NewsFilterDataTransferDelegate: NSObject {
    func transferNewsFilterData(category: NewsCategory, country: NewsCountry, sources: [NewsSource])
}
