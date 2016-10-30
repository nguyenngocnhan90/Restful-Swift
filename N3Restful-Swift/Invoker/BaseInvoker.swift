//
//  BaseInvoker.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/19/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import Foundation

class BaseInvoker: NSObject {
    
    var baseURL: String = RESTContants.kRESTWebserviceUrl
    
    init(controllerName: String!) {
        if controllerName != nil {
            baseURL = RESTContants.kRESTWebserviceUrl + "/" + controllerName
        }
    }
    
    init(url: String) {
        baseURL = url
    }
    
    func requestWithMethodName(_ methodName: String?) -> RESTRequest {
        var url = baseURL
        
        if let methodName = methodName {
            url = "\(baseURL)/\(methodName)"
        }
        
        return RESTRequest(url: url)
    }
}
