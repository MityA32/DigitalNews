//
//  NewsCategory.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 11.10.2023.
//

import Foundation

enum NewsCategory: String, CaseIterable {

    case any = ""
    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology

    var title: String {
        self == .any ? "Any" : rawValue
    }

}
