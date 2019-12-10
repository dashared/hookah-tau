//
//  ClientReservations.swift
//  Hookah Tau
//
//  Created by cstore on 10/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

struct UserReservationsResponce: MyCodable {
    var reservations: [Reservation]
}

class ClientReservationsResolver<Responce: MyCodable>: ApiResolver {
    
    var name: String {
        return "/clients/\(userId)/reservations"
    }
    
    var groupName: String? {
        return "/admin"
    }
    
    var userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    func targetClass() -> Responce.Type {
        return Responce.self
    }
}
