//
//  BlocklistPutResolver.swift
//  Hookah Tau
//
//  Created by cstore on 09/01/2020.
//  Copyright © 2020 Daria Rednikina. All rights reserved.
//

import Foundation

struct RequestBlocklist: MyCodable {
    var blockList: [String]
}

class BlocklistPutResolver: ApiResolver {
    var name: String {
        return "/blocklist"
    }
    
    var groupName: String? {
        return "/admin"
    }
    
    var blockList: [String]
    
    init(blockList: [String]) {
        self.blockList = blockList
    }
    
    func parameters() -> MyCodable? {
        return RequestBlocklist(blockList: blockList)
    }
}
