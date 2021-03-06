//
//  ServerError.swift
//  Hookah Tau
//
//  Created by cstore on 28/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

struct SE: MyCodable {
    var error: String?
}

enum GeneralError: Error {
    case serverError(SE)
    case decodeError
    case noData
    case notFound
    case Error400
    case somethingWentCompletelyWrong
    case alamofireError
}
