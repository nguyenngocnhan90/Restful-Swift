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

class RESTError: NSObject {
    var errorFromResponse:  String?
    var errorFromServer:    String?
    var statusCode: HTTPStatusCode! = .notFound
    
    override init() {
        errorFromServer = ""
        errorFromResponse = ""
    }
    
    init(response: DataResponse<Any>?, error: Error?) {
        if let response = response, let data = response.data {
            let jsonObj = JSON(data: data)
            
            if (jsonObj != JSON.null) {
                let message = jsonObj["error"].stringValue
                self.errorFromServer = message
            }
            else {
                self.errorFromServer = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
            }
            
            statusCode = HTTPStatusCode(rawValue: response.response?.statusCode ?? 0)
        }
        
        if let error = error {
            let castError: NSError = error as NSError!
            let errorString: String! = castError.localizedDescription
            
            self.errorFromResponse = errorString
        }
    }
    
    init(error: Error) {
        let restError = RESTError.init()
        
        let castError: NSError = error as NSError!
        let errorString: String! = castError.localizedDescription
        
        restError.errorFromResponse = errorString
    }
    
}
