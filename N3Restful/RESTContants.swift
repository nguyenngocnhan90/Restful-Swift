//
//  RESTContants.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/19/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import Foundation

public enum RESTStatusCode: Int {
    case Success = 200
    case NotFound = 404
    case BadRequest = 400
    case InternalServerError = 500
    case BadGateWay = 502
    case ServiceUnavailable = 503
}

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
    static let kRESTWebserviceUrl                       = "http://ws.url"
    
    static let kRESTWebserviceResourceUrl               = ""
}
