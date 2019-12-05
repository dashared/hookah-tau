//
//  ChangeReservationResolver.swift
//  Hookah Tau
//
//  Created by cstore on 29/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

class ChangeReservationResolver: ApiResolver {
    
    /// Структура запроса с возможными данными для
    /// изменением бронирования
    struct Request: MyCodable {
        var startTime: Date
        var uuid: String
        var numberOfGuests: Int
        var endTime: Date
    }
    
    var name: String {
        return "/reservations"
    }
    
    var data: Request
    
    init(data: Request) {
        self.data = data
    }
    
    func parameters() -> MyCodable? {
        return data
    }
}
