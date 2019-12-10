//
//  ClientsService.swift
//  Hookah Tau
//
//  Created by cstore on 10/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

class ClientsService {
    private var apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func loadClientsList(completion: @escaping ((Result<[FullUser], GeneralError>) -> Void)) {
        let resolver = ClientsListResolver<ClientsResponce>()
        let request = ApiRequest(resolver: resolver, httpMethod: .get)
        
        apiClient.load(request: request.request) { (res) in
            switch res {
            case .success(let responce):
                guard
                    let d = responce.data,
                    let decodedData = resolver.targetClass().fromJSONToSelf(data: d)
                    else {
                        completion(.failure(GeneralError.decodeError))
                        return }
                
                completion(.success(decodedData.clients))
                return
            case .failure(let err):
                completion(.failure(err))
                return
            }
        }
    }
}
