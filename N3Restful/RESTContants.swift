//
//  RESTContants.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/19/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import Foundation

class RESTContants: NSObject {
    
    // MARK: - RESTRequest Header Keys
    static let kRESTRequestHeaderKey                    = "Header"
    static let kRESTRequestAuthorizationKey             = "Authorization"
    static let kRESTRequestContentTypeKey               = "Content-Type"
    static let kRESTRequestAcceptKey                    = "Accept"
    
    // MARK: - Keys for parser
    static let kRESTSuccessKeyFromResponseData          = "status"
    static let kRESTMessageKeyFromResponseData          = "message"
    static let kRESTDefaultMessageKeyFromResponseData   = "unknow_error"
    
    // MARK: - Prepairing request
    static let kRESTRequestTimeOut                      = 90.0
    
    // MARK: - Webservice url
    static let kRESTWebserviceUrl                       = "https://ws.url/api/"
    
    static let kRESTWebserviceResourceUrl               = ""
}
