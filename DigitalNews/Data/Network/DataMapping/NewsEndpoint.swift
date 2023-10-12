//
//  NewsEndpoint.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 10.10.2023.
//

import Foundation

enum NewsEndpoint: String, Endpoint {
    
    case everything = "/v2/everything"
    case sources = "/v2/top-headlines/sources"
    
    var pathComponent: String {
        rawValue
    }
    
}
