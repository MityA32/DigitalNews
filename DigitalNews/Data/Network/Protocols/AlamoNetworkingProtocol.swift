//
//  AlamoNetworkingProtocol.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 10.10.2023.
//

import Foundation
import Alamofire

protocol AlamoNetworkingProtocol {

    func perform<T: Endpoint, ObjectType: Decodable>(
        _ method: HTTPMethod,
        _ endpoint: T,
        _ parameters: NetworkRequestBodyConvertible,
        of type: ObjectType.Type,
        completion: @escaping (Result<ObjectType?, AFError>) -> ()
    )

}
