//
//  ApiRequest.swift
//  Hookah Tau
//
//  Created by cstore on 28/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

enum CrudMethod: String {
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case get = "GET"
}

class ApiRequest {
    
    // MARK: - Properties
    
    var request: URLRequest
    
    var httpMehtod: CrudMethod
    
    var resolver: ApiResolver
    
    // MARK: - Init
    
    init(resolver: ApiResolver, httpMethod: CrudMethod) {
        self.resolver = resolver
        self.httpMehtod = httpMethod
        
        let url = URL(string: APIClient.BaseUrls.staging + (resolver.groupName ?? "") + resolver.name)!
        self.request = URLRequest(url: url)
        
        self.request.httpBody = resolver.parameters()?.toJSONData()
        self.request.setValue("application/json;charset=utf-8",
                               forHTTPHeaderField: "Content-Type")
        self.request.httpMethod = httpMethod.rawValue
    }
    
}
