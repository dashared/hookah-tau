//
//  RegistrationResolver.swift
//  Hookah Tau
//
//  Created by cstore on 29/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

class RegistrationResolver: ApiResolver {
    // MARK: - types
    
    struct Request: MyCodable {
        var name: String
        var phoneNumber: String
        var code: String
    }
    
    // MARK: - Properties
    
    var name: String {
        return "/register"
    }
    
    var groupName: String? {
        return "/auth"
    }
    
    private var uname: String
    private var code: String
    private var phoneNumber: String
    
    // MARK: - Init
    
    init(name: String, code: String, phoneNumber: String) {
        self.uname = name
        self.code = code
        self.phoneNumber = phoneNumber
    }
    
    func parameters() -> MyCodable {
        return Request(name: uname,
                       phoneNumber: phoneNumber,
                       code: code)
    }
    
    func targetClass() -> MyCodable.Type {
        return User.self
    }
}
