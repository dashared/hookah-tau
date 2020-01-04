//
//  AReservationsResolver.swift
//  Hookah Tau
//
//  Created by cstore on 19/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

struct AReservationResponse: MyCodable {
    var reservations: [ReservationWithUser]
}

/// `/admin/reservations/{establishment id}`
class AReservationsResolver<Response: MyCodable>: ApiResolver {
    
    var name: String {
        return "/reservations/\(establishmentId)"
    }
    
    var groupName: String? {
        return "/admin"
    }
    
    var establishmentId: Int
    
    init(establishmentId: Int) {
        self.establishmentId = establishmentId
    }
    
    func targetClass() -> Response.Type {
        return Response.self
    }
}
