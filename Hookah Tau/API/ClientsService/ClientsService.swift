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
    
    func loadClientsList(completion: @escaping ((Result<[Client], GeneralError>) -> Void)) {
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
    
    func loadReservationsForUser(withUUID uuid: String,
                                 completion: @escaping ((Result<[Reservation], GeneralError>) -> Void)) {
        let resolver = ClientReservationsResolver<UserReservationsResponce>(userId: uuid)
        let request = ApiRequest(resolver: resolver, httpMethod: .get)
        
        apiClient.load(request: request.request) { (res) in
            switch res {
            case .failure(let err):
                completion(.failure(err))
                return
            case .success(let responce):
                guard
                     let d = responce.data,
                     let decData = resolver.targetClass().fromJSONToSelf(data: d)
                    else {
                        completion(.failure(GeneralError.decodeError))
                        return
                }
                
                completion(.success(decData.reservations))
                return
            }
        }
        
    }
    
    /// Метод для удаления или добавления пользователя в чс
    func changeBlockList(whatToDo: CrudMethod, phone: String, completion: @escaping ((Bool) -> Void)) {
        let resolver = BlocklistPutResolver(blockList: [phone])
        let request = ApiRequest(resolver: resolver, httpMethod: whatToDo)
        
        apiClient.load(request: request.request) { (res) in
            switch res {
            case .failure:
                completion(false)
                return
            case .success:
                completion(true)
                return
            }
        }
    }
    
    /// Метод для изменения статуса админки
    func changeAdmin(crud: CrudMethod, data: String, completion: @escaping ((Bool) -> Void)) {
        var resolver: ApiResolver!
        if crud == .put {
            resolver = AddOtherAdminResolver(phone: data)
        } else {
            resolver = DeleteOtherAdminResolver(uuid: data)
        }
        
        let request = ApiRequest(resolver: resolver, httpMethod: crud)
        
        apiClient.load(request: request.request) { result in
            switch result {
            case .failure:
                completion(false)
                return
            case .success:
                completion(true)
                return
            }
        }
    }
}
