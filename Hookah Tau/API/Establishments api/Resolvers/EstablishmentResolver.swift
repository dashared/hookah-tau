//
//  EstablishmentReslver.swift
//  Hookah Tau
//
//  Created by cstore on 28/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation


class EstablishmentResolver<Response>: ApiResolver {
    var name: String {
        return "/admins"
    }
    
    var groupName: String? {
        return "/establishments"
    }
    
    func targetClass() -> Response.Type {
        return Response.self
    }
}
