//
//  RESTError.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/19/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import HTTPStatusCodes

class RestError: NSObject {
    
    fileprivate var error: String?
    fileprivate var errors: [String]?
    
    var errorFromResponse: String?
    
    var statusCode: HTTPStatusCode! = .notFound
    var responseDictionary: [String: Any]?

    override init() {
        error = ""
        errors = []
        errorFromResponse = ""
    }
    
    init(response: DataResponse<Any>?, error: Error?) {
       if let response = response, let data = response.data {
            var jsonObj: JSON? = nil
            do {
                try jsonObj = JSON(data: data)
            }
            catch _ { }
            
            responseDictionary = jsonObj?.dictionaryObject
            
            if let jsonObj = jsonObj, jsonObj != JSON.null {
                if jsonObj["error"] != JSON.null {
                    let message = jsonObj["error"].stringValue
                    self.error = message
                }
                if jsonObj["errors"] != JSON.null {
                    let messages = jsonObj["errors"].arrayObject
                    self.errors = messages as? [String]
                }
            }
            else {
                self.error = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
            }
            
            statusCode = HTTPStatusCode(rawValue: response.response?.statusCode ?? 400)
        }
        
        if let error = error as NSError? {
            self.errorFromResponse = error.localizedDescription
        }
    }
    
    init(error: Error) {
        let restError = RestError.init()
        
        if let error = error as NSError? {
            restError.errorFromResponse = error.localizedDescription
        }
    }
    
    var errorMessage: String? {
        var listErrors = errors ?? []
        if let error = error {
            listErrors.append(error)
        }
        
        guard !listErrors.isEmpty else {
            return nil
        }
        
        return listErrors.joined(separator: "\n")
            .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
}
