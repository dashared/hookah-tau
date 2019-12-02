//
//  AllReservations.swift
//  Hookah Tau
//
//  Created by cstore on 15/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

struct AllReservations: MyCodable {
    var reservations: [Int: [ReservationPeriod]]
    var intervals: [Date: [Int]]
    
    enum CodingKeys: CodingKey {
        case reservations
        case intervals
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let intervalsWithStr = try container.decode([String: [Int]].self, forKey: .intervals)
        reservations = try container.decode([Int: [ReservationPeriod]].self, forKey: .reservations)
        
        let intervArray = intervalsWithStr.map { (element) -> (Date, [Int]) in
            let key = DateFormatter.iso8601Full.date(from: element.key)!
            return (key, element.value)
        }
        
        intervals = Dictionary(uniqueKeysWithValues: intervArray)
    }
}

struct ReservationPeriod: MyCodable {
    var startTime: Date
    var duration: Int
    var endTime: Date
}
