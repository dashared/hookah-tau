//
//  DeleteReservationResolver.swift
//  Hookah Tau
//
//  Created by cstore on 29/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation


class DeleteReservationResolver: ApiResolver {
    
    struct Request: MyCodable {
        var reservationUUID: String
    }
    
    var name: String {
        return "/reservations"
    }
    
    var uuid: String
    
    init(uuid: String) {
        self.uuid = uuid
    }
    
    func parameters() -> MyCodable? {
        return Request(reservationUUID: uuid)
    }
}
