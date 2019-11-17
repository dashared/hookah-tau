//
//  PhoneCodeResolver.swift
//  Hookah Tau
//
//  Created by cstore on 29/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

class PhoneCodeResolver<Response: MyCodable>: ApiResolver {

    // MARK: - types
    
    struct Request: MyCodable {
        var phoneNumber: String
        var code: String
    }
    
    // MARK: - Properties
    
    var name: String {
        return "/phonecode"
    }
    
    var groupName: String? {
        return "/auth"
    }
    
    private var phoneNumber: String
    private var code: String
    
    // MARK: - Init
    
    init(phoneNumber: String, code: String) {
        self.phoneNumber = phoneNumber
        self.code = code
    }
    
    func parameters() -> MyCodable? {
        return Request(phoneNumber: phoneNumber,
                       code: code)
    }
    
    func targetClass() -> Response.Type {
        return Response.self
    }
}
