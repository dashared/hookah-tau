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
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601Full)
        return try? encoder.encode(self)
    }
    
    static func fromJSONToSelf(data: Data) -> Self? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return try? decoder.decode(self, from: data)
    }
    
    static func fromJSONToSelfArray<T: MyCodable>(data : Data) -> [T]? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return try? decoder.decode([T].self, from: data)
    }
}
