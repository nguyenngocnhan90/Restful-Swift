//
//  RESTObject.swift
//  Lixibox
//
//  Created by Nhan Nguyen on 4/14/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import HTTPStatusCodes
import ObjectMapper

class RestObject: NSObject {
    
    var rawValue: String?
    var statusCode: HTTPStatusCode! = .notFound
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
    
}

extension RestObject: Mappable {
    
    func toString() -> String? {
        return rawValue
    }
    
    func toBool() -> Bool {
        if let string = toString() {
            return string == "true" || string == "1"
        }
        
        return false
    }
    
    func toInt() -> Int {
        if let string = toString() {
            return Int(string)!
        }
        
        return 0
    }
    
    func toFloat() -> Float {
        if let string = toString() {
            return Float(string)!
        }
        
        return 0
    }
    
    func toDouble() -> Double {
        if let string = toString() {
            return Double(string)!
        }
        
        return 0
    }
    
}
