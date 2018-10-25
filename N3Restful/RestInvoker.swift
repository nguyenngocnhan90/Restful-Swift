//
//  BaseInvoker.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/19/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import Foundation

class RestInvoker: NSObject {
    
    open var baseURL: String = RestContant.kRESTWebserviceUrl

    init(controllerName: String?) {
        if let controllerName = controllerName {
            baseURL = RestContant.kRESTWebserviceUrl + "/" + controllerName
        }
    }
    
    init(url: String) {
        baseURL = url
    }
    
    open func createRequest(methodName name: String?) -> RestRequest? {
        var url = baseURL
        
        if let name = name {
            url = "\(baseURL)/\(name)"
        }
        
        let request = RestRequest(url: url)
        
        return request
    }
}
