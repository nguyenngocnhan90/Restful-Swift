//
//  RESTError.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/19/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class RESTError: NSObject {
    var errorFromResponse:  String? = ""
    var errorFromServer:    String? = ""
    
    override init() {
        errorFromServer = ""
        errorFromResponse = ""
    }
    
    init(error: NSError) {
        errorFromResponse = error.userInfo["NSDebugDescription"] as? String
    }
    
    init(responseData: NSData?, error: ErrorType?) {
        if (responseData != nil) {
            let jsonObj = JSON(data: responseData!)
            
            if (jsonObj != nil) {
                let message = jsonObj["error"].stringValue
                self.errorFromServer = message
            }
            else {
                self.errorFromServer = NSString(data: responseData!, encoding: NSUTF8StringEncoding) as String?
            }
        }
        
        if(error != nil) {
            let castError: NSError = error as NSError!
            let errorString: String! = castError.localizedDescription
            
            self.errorFromResponse = errorString
        }
    }
    
    init(errorType: ErrorType) {
        let restError = RESTError.init()
        
        let castError: NSError = errorType as NSError!
        let errorString: String! = castError.localizedDescription
        
        restError.errorFromResponse = errorString
    }
    
}

extension RESTError {
    
    func isInvalidPermission() -> Bool {
        if let errorFromResponse = errorFromResponse {
            return errorFromResponse.containsString("Access token is invalid")
        }
        
        return false
    }
    
}