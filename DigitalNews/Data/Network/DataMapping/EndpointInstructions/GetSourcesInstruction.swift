//
//  GetSourcesInstruction.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 11.10.2023.
//

import Foundation

struct GetSourcesInstruction: NetworkRequestBodyConvertible {
    
    var category: String
    var country: String
    
    var data: Data?
    
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "category", value: category),
         URLQueryItem(name: "country", value: country)]
    }
    
    var parameters: [String : Any]?
    
}
