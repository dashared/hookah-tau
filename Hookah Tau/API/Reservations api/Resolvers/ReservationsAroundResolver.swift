//
//  ReservationsAroundResolver.swift
//  Hookah Tau
//
//  Created by cstore on 20/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

struct ReservationsAroundResponse: MyCodable {
    var reservations: [ReservationPeriod]
}

/// ` GET /reservations/around/{reservation id}`
class ReservationsAroundResolver<Response: MyCodable>: ApiResolver {
    
    var groupName: String? {
        return "/reservations"
    }
    
    var name: String {
        return "/around/\(reservationId)"
    }
    
    var reservationId: String
    
    init(reservationId: String) {
        self.reservationId = reservationId
    }
    
    func targetClass() -> Response.Type {
        return Response.self
    }
}
