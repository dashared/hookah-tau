//
//  AuthResolvers.swift
//  Hookah Tau
//
//  Created by cstore on 28/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

class AuthResolver: ApiResolver {

    // MARK: - Request/Response types
    
    struct AuthRequest: MyCodable {
        var phoneNumber: String
    }
    
    struct AuthResponse: MyCodable {
        var isUserRegistered: Bool
    }
    
    // MARK: - Properties
    
    private var phone: String
    
    var name: String {
        return "/login"
    }
    
    var groupName: String? {
        return "/auth"
    }
    
    // MARK: - Init
    
    init(phone: String) {
        self.phone = phone
    }
    
    func parameters() -> MyCodable {
        return AuthRequest(phoneNumber: self.phone)
    }
    
    func targetClass() -> MyCodable.Type {
        return AuthResponse.self
    }
}

//class RegistrationResolver: ApiResolver {
//
//}
//
//class PhoneCodeResolver: ApiResolver {
//
//}
