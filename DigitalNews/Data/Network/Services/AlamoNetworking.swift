//
//  AlamoNetworking.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 10.10.2023.
//

import Foundation
import Alamofire

final class AlamoNetworking: AlamoNetworkingProtocol {

    private var host: String
    private var headers: [String : String]
    
    init(_ hostString: String, headers: [String : String] = [:]) {
        self.host = hostString
        self.headers = headers
    }

    func perform<T: Endpoint, ObjectType: Decodable>(
        _ method: HTTPMethod,
        _ endpoint: T, 
        _ parameters: NetworkRequestBodyConvertible,
        of type: ObjectType.Type,
        completion: @escaping (Result<ObjectType?, AFError>) -> Void
    ) {
        AF
        .request(
            composeRequest(host + "\(endpoint.pathComponent)", parameters),
            method: method,
            parameters: parameters.parameters,
            headers: HTTPHeaders(headers)
        )
        .responseDecodable(of: ObjectType.self) { response in
            if let error = response.error {
                completion(.failure(error))
            } else {
                completion(.success(response.value))
            }
        }
    }

    private func composeRequest(
        _ host: String,
        _ parameters: NetworkRequestBodyConvertible
    ) -> String {
        var urlComps = URLComponents(string: host)!
        urlComps.queryItems = parameters.queryItems
        return urlComps.url?.absoluteString ?? ""
    }

}
