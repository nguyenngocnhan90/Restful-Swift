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
    
    static func parseError(responseData: NSData?, error: ErrorType?) -> RESTError {
        
        let restError = RESTError.init()
        
        if (responseData != nil) {
            let jsonObj: JSON = JSON(data: responseData!)
            
            if (jsonObj != nil) {
                let errorJson: JSON = jsonObj["error"]
                
                let message = errorJson[RESTContants.kRESTMessageKeyFromResponseData].stringValue
                
                if(message.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0) {
                    restError.errorFromServer = message
                }
                else {
                    restError.errorFromServer = RESTContants.kRESTDefaultMessageKeyFromResponseData
                }
            }
            else {
                restError.errorFromServer = NSString(data: responseData!, encoding: NSUTF8StringEncoding) as String?
            }
        }
        
        if(error != nil) {
            let castError: NSError = error as NSError!
            let errorString: String! = castError.localizedDescription
            
            restError.errorFromResponse = errorString
        }
        
        return restError
    }
    
    init(errorType: ErrorType) {
        let restError = RESTError.init()
        
        let castError: NSError = errorType as NSError!
        let errorString: String! = castError.localizedDescription
        
        restError.errorFromResponse = errorString
    }
}