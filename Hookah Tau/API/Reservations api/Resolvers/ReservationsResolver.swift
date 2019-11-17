//
//  ReservationsResolver.swift
//  Hookah Tau
//
//  Created by cstore on 06/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

struct ReservationsResponce: MyCodable {
    var reservations: [Reservation]
}

class ReservationsResolver<Response: MyCodable>: ApiResolver {
    var name: String {
        return "/reservations"
    }
    
    func targetClass() -> Response.Type {
        return Response.self
    }
}

class AllReservationsResolver<Response: Codable>: ApiResolver {
    
    struct Request: MyCodable {
        var establishmentUUID: Int
    }
    
    var name: String {
        return "/all/\(self.establishmentID)"
    }

    var groupName: String? {
        return "/reservations"
    }
    
    var establishmentID: Int
    
    init(establishmentID: Int) {
        self.establishmentID = establishmentID
    }
    
    func targetClass() -> Response.Type {
        return Response.self
    }
}
