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
    var sources: String
    var sortBy: String
    var pageSize: String
    var page: String
    
    init(q: String, sources: String, sortBy: String, pageSize: String = GetNewsInstruction.requestPortionSize, page: String) {
        self.q = q
        self.sources = sources
        self.sortBy = sortBy
        self.pageSize = pageSize
        self.page = page
    }
    
    var data: Data? { nil }
    
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "q", value: q),
         URLQueryItem(name: "sources", value: sources),
         URLQueryItem(name: "sortBy", value: sortBy),
         URLQueryItem(name: "pageSize", value: pageSize),
         URLQueryItem(name: "page", value: page)]
    }
    
    var parameters: [String : Any]? {
        ["q" : q, "sources" : sources, "sortBy" : sortBy, "pageSize" : pageSize, "page" : page]
    }
    
}
