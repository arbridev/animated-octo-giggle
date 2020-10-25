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
    
    /// Fetch photos
    ///
    /// - Parameters:
    ///     - parameters: Query parameters.
    ///     - completion: Response.
    func photos(parameters: [String:Any], completion: @escaping APIResponse<Photos>) {
        var parameters = parameters
        parameters["client_id"] = UnsplashKeys.accessKey
        NetworkRequests.getRequest(host: host, endpoint: "/photos", parameters: parameters) { (responseStr, responseObj, error) in
            completion(responseStr, responseObj, error)
        }
    }
    
    /// Fetch a single photo
    ///
    /// - Parameters:
    ///     - parameters: Query parameters.
    ///     - embeddedParams: Url parameters (id).
    ///     - completion: Response.
    func photo(parameters: [String:Any], embeddedParams: [String:Any], completion: @escaping APIResponse<Photo>) {
        var parameters = parameters
        parameters["client_id"] = UnsplashKeys.accessKey
        NetworkRequests.getRequest(host: host, endpoint: "/photos/\(embeddedParams["id"] ?? "")", parameters: parameters) { (responseStr, responseObj, error) in
            completion(responseStr, responseObj, error)
        }
    }
    
    /// Fetch user profile
    ///
    /// - Parameters:
    ///     - parameters: Query parameters.
    ///     - embeddedParams: Url parameters (username).
    ///     - completion: Response.
    func userProfile(parameters: [String:Any], embeddedParams: [String:Any], completion: @escaping APIResponse<UserProfile>) {
        var parameters = parameters
        parameters["client_id"] = UnsplashKeys.accessKey
        NetworkRequests.getRequest(host: host, endpoint: "/users/\(embeddedParams["username"] ?? "")", parameters: parameters) { (responseStr, responseObj, error) in
            completion(responseStr, responseObj, error)
        }
    }
    
    /// Fetch photo statistics
    ///
    /// - Parameters:
    ///     - parameters: Query parameters.
    ///     - embeddedParams: Url parameters (id).
    ///     - completion: Response.
    func photoStatistics(parameters: [String:Any], embeddedParams: [String:Any], completion: @escaping APIResponse<PhotoStatistics>) {
        var parameters = parameters
        parameters["client_id"] = UnsplashKeys.accessKey
        NetworkRequests.getRequest(host: host, endpoint: "/photos/\(embeddedParams["id"] ?? "")/statistics", parameters: parameters) { (responseStr, responseObj, error) in
            completion(responseStr, responseObj, error)
        }
    }
    
    /// Fetch user photos
    ///
    /// - Parameters:
    ///     - parameters: Query parameters.
    ///     - embeddedParams: Url parameters (username).
    ///     - completion: Response.
    func userPhotos(parameters: [String:Any], embeddedParams: [String:Any], completion: @escaping APIResponse<UserPhotos>) {
        var parameters = parameters
        parameters["client_id"] = UnsplashKeys.accessKey
        NetworkRequests.getRequest(host: host, endpoint: "/users/\(embeddedParams["id"] ?? "")/photos", parameters: parameters) { (responseStr, responseObj, error) in
            completion(responseStr, responseObj, error)
        }
    }
    
}



