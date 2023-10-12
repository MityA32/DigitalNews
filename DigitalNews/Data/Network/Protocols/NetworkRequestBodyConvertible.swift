//
//  NetworkRequestBodyConvertible.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 10.10.2023.
//

import Foundation

protocol NetworkRequestBodyConvertible {

    var data: Data? { get }
    var queryItems: [URLQueryItem]? { get }
    var parameters: [String : Any]? { get }

}
