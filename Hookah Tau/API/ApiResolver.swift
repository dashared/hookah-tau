//
//  Resolver.swift
//  Hookah Tau
//
//  Created by cstore on 28/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

protocol ApiResolver: class {
    
    var name: String { get }
    
    var groupName: String? { get }
    
    /// Parameter for request
    func parameters() -> MyCodable?
}

extension ApiResolver {
    var groupName: String? { return nil }
    
    func parameters() -> MyCodable? { return nil }
}
