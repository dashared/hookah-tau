//
//  GetClientByPhoneNumberResolver.swift
//  Hookah Tau
//
//  Created by cstore on 14/01/2020.
//  Copyright © 2020 Daria Rednikina. All rights reserved.
//

import Foundation

struct ClientInResponce: MyCodable {
    var client: FullUser
}

/// `GET /admin/clients/by-phone/{user id}`
class GetClientByPhoneNumberResolver<Responce: MyCodable>: ApiResolver {
    
    var name: String {
        return "/clients/by-phone/\(userPhone)"
    }
    
    var groupName: String? {
        return "/admin"
    }
    
    var userPhone: String
    
    init(userPhone: String) {
        self.userPhone = userPhone
    }
    
    func targetClass() -> Responce.Type {
        return Responce.self
    }
}
