//
//  AddOtherAdminResolver.swift
//  Hookah Tau
//
//  Created by cstore on 20/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

/// `PUT /admin/other`
class AddOtherAdminResolver: ApiResolver {
    /// Request struct
    struct Request: MyCodable {
        var newAdmin: String
    }
    
    var name: String {
        return "/other"
    }
    
    var groupName: String? {
        return "/admin"
    }
    
    var phone: String
    
    init(phone: String) {
        self.phone = phone
    }
    
    func parameters() -> MyCodable? {
        return Request(newAdmin: phone)
    }
}
