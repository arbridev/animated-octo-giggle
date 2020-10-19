//
//  UnsplashAPIHandler.swift
//  DigitalPhotographer
//
//  Created by Armando Brito on 10/18/20.
//  Copyright © 2020 arbridev. All rights reserved.
//

import Foundation
import Alamofire

struct APIError {
    
    var error: Error
    var statusCode: Int?
    
    init(error: Error, statusCode: Int?) {
        self.error = error
        self.statusCode = statusCode
    }
}

typealias APIResponse<T> = (String, T?, APIError?) -> ()

class UnsplashAPIHandler {
    
    let host = "https://api.unsplash.com"
    
    func photos(parameters: [String:Any], completion: @escaping APIResponse<Photos>) {
        var parameters = parameters
        parameters["client_id"] = UnsplashKeys.accessKey
        NetworkRequests.getRequest(host: host, endpoint: "/photos", parameters: parameters) { (responseStr, responseObj, error) in
            completion(responseStr, responseObj, error)
        }
    }
    
}



