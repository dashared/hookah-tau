//
//  AChangeReservationResolver.swift
//  Hookah Tau
//
//  Created by cstore on 20/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation


/// `PUT /admin/reservations`

class AChangeReservationResolver: ApiResolver {
    
    var name: String {
        return "/reservations"
    }
    
    var groupName: String? {
        return "/admin"
    }
    
    var data: ChangeReservationResolver.Request
    
    init(data: ChangeReservationResolver.Request) {
        self.data = data
    }
    
    func parameters() -> MyCodable? {
        return data
    }
}

