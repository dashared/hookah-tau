//
//  DeleteOtherAdminResolver.swift
//  Hookah Tau
//
//  Created by cstore on 10/01/2020.
//  Copyright © 2020 Daria Rednikina. All rights reserved.
//

import Foundation


class DeleteOtherAdminResolver: ApiResolver {
    
    var name: String {
        return "/other"
    }
    
    var groupName: String? {
        return "/admin"
    }
    
    struct Request: MyCodable {
        let badAdmin: String
    }
    
    let uuid: String
    
    init(uuid: String) {
        self.uuid = uuid
    }
    
    func parameters() -> MyCodable? {
        return Request(badAdmin: self.uuid)
    }
}
