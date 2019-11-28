//
//  CreateReservationResolver.swift
//  Hookah Tau
//
//  Created by cstore on 27/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

class CreateReservationResolver<Response: Codable>: ApiResolver {
    
    var name: String {
        return "/reservations"
    }
    
    var data: ReservationData
    
    init(data: ReservationData) {
        self.data = data
    }
    
    func targetClass() -> Response.Type {
        return Response.self
    }
}
