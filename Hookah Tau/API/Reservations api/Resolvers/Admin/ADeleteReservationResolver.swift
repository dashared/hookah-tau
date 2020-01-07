//
//  ADeleteReservationResolver.swift
//  Hookah Tau
//
//  Created by cstore on 07/01/2020.
//  Copyright © 2020 Daria Rednikina. All rights reserved.
//

import Foundation

class ADeleteReservationResolver: ApiResolver {

    struct Request: MyCodable {
        var reservation: String
    }
    
    var name: String {
        return "/reservations"
    }

    var groupName: String? {
        return "/admin"
    }
    
    var uuid: String
    
    init(uuid: String) {
        self.uuid = uuid
    }
    
    func parameters() -> MyCodable? {
        return Request(reservation: uuid)
    }
}
