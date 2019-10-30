//
//  APIClient.swift
//  Hookah Tau
//
//  Created by cstore on 28/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import Foundation
import Alamofire

/// http://iko.soy/hookah-tau-docs/latest/index.html
class APIClient {
    typealias CompletionBlock = (Result<Codable, GeneralError>) -> Void
     
    enum BaseUrls {
        static let staging = "https://hookah-tau-staging.herokuapp.com"
        // static let production = ""
    }
    
    /// Basic
    func load(request: URLRequest, completion: @escaping CompletionBlock) {
        AF.request(request).response { response in
            
            if let error = self.getErrorFromResponce(response) {
                completion(.failure(error))
                return
            }
            
            completion(.success(response.data))
        }
    }
    
    /// Обработка ошибок которую мы заслужили
    private func getErrorFromResponce(_ response: AFDataResponse<Data?>) -> GeneralError? {
        if let statusCode = response.response?.statusCode {
            switch statusCode {
            case 200...299:
                return nil
            case 422:
                if let data = response.data, let error = SE.fromJSONToSelf(data: data) {
                    return GeneralError.serverError(error)
                }
                
                fallthrough // прекрасно, я знаю
            default:
                return GeneralError.somethingWentCompletelyWrong
            }
        }
        
        return GeneralError.somethingWentCompletelyWrong
    }
}
