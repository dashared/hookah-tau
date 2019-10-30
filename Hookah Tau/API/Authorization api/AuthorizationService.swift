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
    
    /// Check if phone number is registered and send verification code to that number.
    /// - Parameter phoneNumber: (_xx) xxx xx xx - 9 numbers withount +7 9...
    /// - Parameter completion: isUserRegistered and Error
    func authenticate(withPhone phoneNumber: String,
                      completion: @escaping (Result<Bool, GeneralError>) -> Void) {
        let resolver = AuthResolver<AuthResponse>(phoneNumber: phoneNumber)
        let request = ApiRequest(resolver: resolver, httpMethod: .post)
        
        apiClient.load(request: request.request) { (result) in
            switch result {
            case .failure(let err):
                completion(.failure(err))
            case .success(let data):
                guard
                    let d = data as? Data,
                    let decodedData = resolver.targetClass().fromJSONToSelf(data: d)
                else {
                    completion(.failure(GeneralError.decodeError))
                    return
                }
                
                completion(.success(decodedData.isUserRegistered))
            }
        }
    }
    
    /// Verify login of  **already existing user** with phone number and verification code.
    func phonecode(phoneNumber: String,
                   code: String,
                   completion: @escaping (Result<User, Error>) -> Void) {
        let resolver = PhoneCodeResolver<User>(phoneNumber: phoneNumber, code: code)
        let request = ApiRequest(resolver: resolver, httpMethod: .post)
        
        apiClient.load(request: request.request) { result in
            switch result {
            case .failure(let err):
                completion(.failure(err))
            case .success(let data):
                guard
                    let unwrappedData = data as? Data,
                    let decodedData = resolver.targetClass().fromJSONToSelf(data: unwrappedData)
                else {
                    completion(.failure(GeneralError.decodeError))
                    return
                }
                
                completion(.success(decodedData))
            }
        }
    }
    
    
    /// Register new user with a given name, phone number and verification code.
    func register(name: String,
                  code: String,
                  phoneNumber: String, completion: @escaping (Result<User, Error>) -> Void) {
        let resolver = RegistrationResolver<User>(name: name, code: code, phoneNumber: phoneNumber)
        let request = ApiRequest(resolver: resolver, httpMethod: .post)
        
        apiClient.load(request: request.request) { result in
            switch result {
            case .failure(let err):
                completion(.failure(err))
            case .success(let data):
                guard
                    let unwrappedData = data as? Data,
                    let decodedData = resolver.targetClass().fromJSONToSelf(data: unwrappedData)
                else {
                    completion(.failure(GeneralError.decodeError))
                    return
                }
                
                completion(.success(decodedData))
            }
        }
    }
}
