//
//  AdminServise.swift
//  Hookah Tau
//
//  Created by cstore on 20/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation

class SettingsService {
    
    private var apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func addOtherAdmin(phone: String, completion: @escaping ((Bool) -> Void)) {
        let resolver = AddOtherAdminResolver(phone: phone)
        let request = ApiRequest(resolver: resolver, httpMethod: .put)
        
        apiClient.load(request: request.request) { result in
            switch result {
            case .failure:
                completion(false)
                return
            case .success:
                completion(true)
                return
            }
        }
    }
}
