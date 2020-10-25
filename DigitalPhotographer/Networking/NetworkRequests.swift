//
//  NetworkRequests.swift
//  DigitalPhotographer
//
//  Created by Armando Brito on 10/18/20.
//  Copyright © 2020 arbridev. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkRequests {
    
    static func getRequest(host: String, endpoint: String, parameters: [String:Any], completion: @escaping (String, APIError?)->()) {
        if let encodedUrl = "\(host)\(endpoint)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            AF.request(encodedUrl,
                                method: .get,
                                parameters: parameters,
                                encoding: URLEncoding.queryString)
                .validate().responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        completion(String(decoding: data, as: UTF8.self), nil)
                    } else {
                        completion("", nil)
                    }
                case .failure(let error):
                    completion("Response: " + String(describing: response), APIError(error: error, statusCode: response.response?.statusCode))
                }
            }
        }
    }
    
    static func getRequest<T: Decodable>(host: String, endpoint: String, parameters: [String:Any], completion: @escaping APIResponse<T>) {
        if let encodedUrl = "\(host)\(endpoint)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            AF.request(encodedUrl,
                                method: .get,
                                parameters: parameters,
                                encoding: URLEncoding.queryString)
                .validate().responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        let object = try JSONDecoder().decode(T.self, from: response.data ?? Data())
                        completion(String(decoding: response.data ?? Data(), as: UTF8.self), object, nil)
                    } catch {
                        print(error)
                        completion("Response: " + String(describing: response), nil, APIError(error: error, statusCode: response.response?.statusCode))
                    }
                case .failure(let error):
                    completion("Response: " + String(describing: response), nil, APIError(error: error, statusCode: response.response?.statusCode))
                }
            }
        }
    }
    
}
