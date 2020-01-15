//
//  ACreateReservationResolver.swift
//  Hookah Tau
//
//  Created by cstore on 14/01/2020.
//  Copyright © 2020 Daria Rednikina. All rights reserved.
//

import Foundation

struct ACreateAdminResonce: MyCodable {
    var reservationUUID: String
}

class ACreateReservationResolver<Responce: MyCodable>: ApiResolver {
    var name: String {
        return "/reservations"
    }
    
    var groupName: String? {
        return "/admin"
    }
    
    var data: AdminCreateReservation
    
    init(data: AdminCreateReservation) {
        self.data = data
    }
    
    func parameters() -> MyCodable? {
        return data
    }
    
    func targetClass() -> Responce.Type {
        return Responce.self
    }
}
