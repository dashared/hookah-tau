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
    
    func deleteReservation(isAdmin: Bool, uuid: String, completion: @escaping ((Bool) -> Void)) {
        var resolver: ApiResolver!
        if isAdmin {
            resolver = ADeleteReservationResolver(uuid: uuid)
        } else {
            resolver = DeleteReservationResolver(uuid: uuid)
        }
    
        let request = ApiRequest(resolver: resolver, httpMethod: .delete)
        
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
    
    func updateReservation(startTime: Date,
                           numberOfGuests: Int,
                           endTime: Date,
                           uuid: String,
                           isAdmin: Bool,
                           completion: @escaping ((Bool) -> Void)) {
        
        let reservation = ChangeReservationResolver.Request(startTime: startTime,
                                                            uuid: uuid,
                                                            numberOfGuests: numberOfGuests,
                                                            endTime: endTime)
        var resolver: ApiResolver!
        if isAdmin {
            resolver = AChangeReservationResolver(data: reservation)
        } else {
            resolver = ChangeReservationResolver(data: reservation)
        }
        
        let request = ApiRequest(resolver: resolver, httpMethod: .put)
        
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
    
    func getAdminReservations(establishmentId: Int, completion: @escaping ((Result<[ReservationWithUser], GeneralError>)-> Void)) {
        let resolver = AReservationsResolver<AReservationResponse>(establishmentId: establishmentId)
        let request = ApiRequest(resolver: resolver, httpMethod: .get)
        
        apiClient.load(request: request.request) { (res) in
            switch res {
            case .failure(let err):
                completion(.failure(err))
                return
            case .success(let response):
                guard
                    let d = response.data,
                    let decodedData = resolver.targetClass().fromJSONToSelf(data: d)
                    else {
                        completion(.failure(GeneralError.decodeError))
                        return
                }
                
                completion(.success(decodedData.reservations))
                return
            }
        }
    }
    
    func getReservationsAround(uuid: String, completion: @escaping((Result<[ReservationPeriod], GeneralError>) -> Void)) {
        let resolver = ReservationsAroundResolver<ReservationsAroundResponse>(reservationId: uuid)
        let request = ApiRequest(resolver: resolver, httpMethod: .get)
        
        apiClient.load(request: request.request) { (res) in
            switch res {
            case .failure(let err):
                completion(.failure(err))
                return
            case .success(let response):
                guard
                    let d = response.data,
                    let decodedData = resolver.targetClass().fromJSONToSelf(data: d)
                    else {
                        completion(.failure(GeneralError.decodeError))
                        return
                }
                
                completion(.success(decodedData.reservations))
                return
            }
        }
    }
    
    func createReservation(reservation: AdminCreateReservation, completion: @escaping ((Result<String, GeneralError>) -> Void)) {
        let resolver = ACreateReservationResolver<ACreateAdminResonce>(data: reservation)
        let request = ApiRequest(resolver: resolver, httpMethod: .post)
        
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
                
                completion(.success(decData.reservationUUID))
            }
        }
    }
}
