//
//  Resolver.swift
//  Hookah Tau
//
//  Created by cstore on 28/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

protocol ApiResolver {
    var name: String { get }
    
    var groupName: String? { get }
    
    func parameters() -> MyCodable
    
    func targetClass() -> MyCodable.Type
}
