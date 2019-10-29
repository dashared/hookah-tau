//
//  AuthorizationService.swift
//  Hookah Tau
//
//  Created by cstore on 28/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

/// Слой методов для авторизации пользователя в приложении
class AuthorizationService {
    private var apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func authenticate(withPhone phoneNumber: String,
                      completion: @escaping (Result<Bool, Error>) -> Void) {
        let resolver = AuthResolver(phoneNumber: phoneNumber)

        let request = ApiRequest(resolver: resolver, httpMethod: .post)
        
        apiClient.load(request: request.request) { (result) in
            switch result {
            case .failure(let err):
                completion(.failure(err))
            case .success(let data):
                print(data) // TODO remove
                
                guard
                    let d = data as? Data,
                    let decodedData = resolver.targetClass().fromJSONToSelf(data: d) as? AuthResolver.Response
                else {
                    completion(.failure(ServerError.internalServerError))
                    return
                }
                
                completion(.success(decodedData.isUserRegistered))
            }
        }
    }
    
    func phonecode() {
        //let resolver = PhoneCodeResolver()
    }
    
    func register() {
        //let resolver = RegistrationResolver()
    }
}
