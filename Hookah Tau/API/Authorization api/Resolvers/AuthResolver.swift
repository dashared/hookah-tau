//
//  AuthResolvers.swift
//  Hookah Tau
//
//  Created by cstore on 28/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

struct AuthResponse: MyCodable {
    var isUserRegistered: Bool
}

class AuthResolver<Response: MyCodable>: ApiResolver {
    
    // MARK: - Request/Response types
    
    struct Request: MyCodable {
        var phoneNumber: String
    }
    
    // MARK: - Properties
    
    private var phoneNumber: String
    
    var name: String {
        return "/login"
    }
    
    var groupName: String? {
        return "/auth"
    }
    
    // MARK: - Init
    
    init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
    }
    
    func parameters() -> MyCodable? {
        return Request(phoneNumber: phoneNumber)
    }
    
    func targetClass() -> Response.Type {
        return Response.self
    }
}


