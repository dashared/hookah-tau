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
    
    func createReservation(data: ReservationData,
                           completion: @escaping ((Result<Reservation, GeneralError>) -> Void)) {
        // for 1 time use
        struct Response: MyCodable {
            var reservationUUID: String
        }
        
        // local map for output
        func map(data: ReservationData, id: String) -> Reservation {
            
            return Reservation(uuid: id,
                               establishment: data.establishment,
                               startTime: data.startTime,
                               endTime: data.endTime,
                               numberOfGuests: data.numberOfGuests,
                               reservedTable: data.reservedTable)
        }
        
        let resolver = CreateReservationResolver<Response>(data: data)
        let request = ApiRequest(resolver: resolver, httpMethod: .post)
        
        apiClient.load(request: request.request) { result in
            switch result {
            case .failure(let err):
                completion(.failure(err))
            case .success(let response):
                guard
                    let d = response.data,
                    let id = resolver.targetClass().fromJSONToSelf(data: d)?.reservationUUID
                else {
                    completion(.failure(GeneralError.decodeError))
                    return
                }
                
                completion(.success(map(data: data, id: id)))
            }
        }
    }
}
