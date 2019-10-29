//
//  APIClient.swift
//  Hookah Tau
//
//  Created by cstore on 28/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation
import Alamofire

/// http://iko.soy/hookah-tau-docs/latest/index.html
class APIClient {
    typealias CompletionBlock = (Result<Codable, Error>) -> Void
     
    enum BaseUrls {
        static let staging = "https://hookah-tau-staging.herokuapp.com"
        // static let production = ""
    }
    
    /// Basic
    func load(request: URLRequest, completion: @escaping CompletionBlock) {
        AF.request(request).response { response in
            
            if let error = response.error, let _ = error.responseCode {
                completion(.failure(ServerError.internalServerError))
            }
            
            completion(.success(response.data))
        }
    }
}
