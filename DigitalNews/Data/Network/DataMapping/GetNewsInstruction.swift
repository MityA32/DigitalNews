//
//  GetNewsInstruction.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 10.10.2023.
//

import Foundation

struct GetNewsInstruction: NetworkRequestBodyConvertible {
    static let requestPortionSize = "\(15)"
    
    var q: String
    var pageSize: String
    var page: String
    var apiKey: String
    
    init(q: String, pageSize: String = GetNewsInstruction.requestPortionSize, page: String) {
        self.q = q
        self.pageSize = pageSize
        self.page = page
        self.apiKey = APIKeys.newsApi
    }
    
    var data: Data? { nil }
    
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "q", value: q),
         URLQueryItem(name: "pageSize", value: pageSize),
         URLQueryItem(name: "page", value: page),
         URLQueryItem(name: "apiKey", value: apiKey)
        ]
    }
    
    var parameters: [String : Any]? {
        ["q" : q, "pageSize" : pageSize, "page" : page, "apiKey" : apiKey]
    }
    
}
