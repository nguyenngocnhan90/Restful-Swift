//
//  BaseInvoker.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/19/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import Foundation

class RESTInvoker: NSObject {
    
    open var baseURL: String = RESTContant.kRESTWebserviceUrl

    init(controllerName: String?) {
        if let controllerName = controllerName {
            baseURL = RESTContant.kRESTWebserviceUrl + "/" + controllerName
        }
    }
    
    init(url: String) {
        baseURL = url
    }
    
    open func createRequest(methodName name: String?) -> RESTRequest? {
        var url = baseURL
        
        if let name = name {
            url = "\(baseURL)/\(name)"
        }
        
        let request = RESTRequest(url: url)
        
        return request
    }
}
