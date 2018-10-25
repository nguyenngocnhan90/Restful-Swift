//
//  RESTContants.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/19/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import Foundation

class RestContant: NSObject {
    
    // MARK: - RESTRequest Header Keys
    static let requestHeaderKey = "Header"
    static let requestAuthorizationKey = "Authorization"
    static let requestContentTypeKey = "Content-Type"
    static let requestAcceptKey = "Accept"
    
    // MARK: - Keys for parser
    static let successKeyFromResponseData = "status"
    static let messageKeyFromResponseData = "message"
    static let defaultMessageKeyFromResponseData = "unknow_error"
    
    // MARK: - Prepairing request
    static let requestTimeOut = 20.0
    
    // MARK: - Webservice url
    static let kRESTWebserviceUrl                       = "http://ws.url"
    
}
