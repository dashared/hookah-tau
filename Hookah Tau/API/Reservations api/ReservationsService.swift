//
//  ReservationsService.swift
//  Hookah Tau
//
//  Created by cstore on 06/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation
import Alamofire

/// Слой методов для авторизации пользователя в приложении
class ReservationsService {
    private var apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    /// Gets all reservations made by the current user.
    func loadUsersReservations(completion: @escaping (Result<[Reservation], GeneralError>) -> Void) {
        let resolver = ReservationsResolver<ReservationsResponce>()
        
        let request = ApiRequest(resolver: resolver, httpMethod: .get)
        apiClient.load(request: request.request) { (result) in
            switch result {
            case .failure(let err):
                completion(.failure(err))
            case .success(let response):
                guard
                    let d = response.data,
                    let decodedData = resolver.targetClass().fromJSONToSelf(data: d)
                else {
                    completion(.failure(GeneralError.decodeError))
                    return
                }
                
                completion(.success(decodedData.reservations))
            }
        }
    }
    
    func deleteReservation() {
        
    }
    
    func updateReservation() {
        
    }
    
    func createReservation() {
        
    }
    
    func getAllReservations(establishmentID: Int,
                            completion: @escaping ((Result<AllReservations, GeneralError>) -> Void)) {
        let resolver = AllReservationsResolver<AllReservations>(establishmentID: establishmentID)
        
        let request = ApiRequest(resolver: resolver, httpMethod: .get)
        
        apiClient.load(request: request.request) { result in
            switch result {
            case .failure(let err):
                completion(.failure(err))
            case .success(let response):
                guard
                    let d = response.data,
                    let decodedData = resolver.targetClass().fromJSONToSelf(data: d)
                else {
                    completion(.failure(GeneralError.decodeError))
                    return
                }
                
                completion(.success(decodedData))
            }
        }
    }
}
