//
//  Reservation.swift
//  Hookah Tau
//
//  Created by cstore on 06/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation


struct Reservation: MyCodable {
    
    var uuid: String
    var establishment: Int
    var startTime: String
    var endTime: String
    var numberOfGuests: Int
    var reservedTable: Int
    
}

/// `Reservation` without `uuid`
struct ReservationData: MyCodable {
    
    var establishment: Int
    var startTime: String
    var endTime: String
    var numberOfGuests: Int
    var reservedTable: Int
    
}
