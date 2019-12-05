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
    typealias CompletionBlock = (Result<AFDataResponse<Data?>, GeneralError>) -> Void
     
    private init() {}
    
    /// Shared instance of the client
    static let shared = APIClient()
    
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
            
            completion(.success(response))
        }
    }
    
    /// Обработка ошибок которую мы заслужили
    private func getErrorFromResponce(_ response: AFDataResponse<Data?>) -> GeneralError? {
        if let statusCode = response.response?.statusCode {
            switch statusCode {
            case 200...299:
                return nil
            case 400:
                // спасибо илья я печатаю ошибки хаскеля в консоль ура
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(String(describing: json))")
                }
            case 422:
                if let data = response.data, let error = SE.fromJSONToSelf(data: data) {
                    print(error)
                    return GeneralError.serverError(error)
                }
                
                fallthrough // прекрасно, я знаю
            default:
                return GeneralError.somethingWentCompletelyWrong
            }
        }
        
        if let _ = response.error {
            return GeneralError.alamofireError
        }
        
        return GeneralError.somethingWentCompletelyWrong
    }
}
