//
//  ApiParameters.swift
//  Hookah Tau
//
//  Created by cstore on 28/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

protocol MyCodable: Codable {
    func toJSONData() -> Data?
    
    static func fromJSONToSelf(data: Data) -> Self?
}

extension MyCodable {
    func toJSONData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    static func fromJSONToSelf(data: Data) -> Self? {
        return try? JSONDecoder().decode(self, from: data)
    }
}
