//
//  Sources+Decodable.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 11.10.2023.
//

import Foundation

struct SourcesModel: Decodable {
    let sources: [NewsSource]
}

struct NewsSource: Decodable, Equatable {

    let id: String
    let name: String
    let description: String
    let url: String
    let category: String
    let language: String
    let country: String

}
