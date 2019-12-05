//
//  EstablishmentService.swift
//  Hookah Tau
//
//  Created by cstore on 28/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

class EstablishmentSevice {
    private var apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func loadAdmins(completion: @escaping ((Result<[Int: String], GeneralError>) -> Void)) {
        let resolver = EstablishmentResolver<[Int: String]>()
        let request = ApiRequest(resolver: resolver, httpMethod: .get)
        
        apiClient.load(request: request.request) { result in
            switch result {
            case .failure(let err):
                completion(.failure(err))
            case .success(let response):
                guard
                    let data = response.data,
                    let decondedData = try? JSONDecoder().decode([Int: String].self, from: data)
                else {
                    completion(.failure(.decodeError))
                    return
                }
                
                completion(.success(decondedData))
            }
        }
    }
}
