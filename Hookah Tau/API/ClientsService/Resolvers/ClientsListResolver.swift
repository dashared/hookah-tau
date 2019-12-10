//
//  ClientsListResolver.swift
//  Hookah Tau
//
//  Created by cstore on 10/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

struct ClientsResponce: MyCodable {
    var clients: [FullUser]
}

class ClientsListResolver<Responce: MyCodable>: ApiResolver {
    
    var name: String {
        return "/clients"
    }
    
    var groupName: String? {
        return "/admin"
    }
    
    func targetClass() -> Responce.Type {
        return Responce.self
    }
}
