//
//  Serializable.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/19/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import Foundation

@objcMembers
class RestParam: NSObject {
    
    var toDictionary: [String: Any] {
        var dict = [String: Any]()
        let properties = propertyNames
        
        for prop in properties {
            if let value = value(forKey: prop) {
                if let value = value as? String {
                    dict[prop] = value
                }
                else if let value = value as? Int {
                    dict[prop] = value
                }
                else if let value = value as? Double {
                    dict[prop] = value
                }
                else if let value = value as? Bool {
                    dict[prop] = value ? 1 : 0
                }
                else if let value = value as? [String] {
                    dict[prop] = value
                }
                else if let value = value as? RestParam {
                    dict[prop] = value.toDictionary
                }
                else if let list = value as? [RestParam] {
                    dict[prop] = list.map({ $0.toDictionary })
                }
            }
        }
        
        return dict
   }

}

extension NSObject {
    
    var propertyNames: [String] {
        let mirror = Mirror(reflecting: self)
        return mirror.children.compactMap { $0.label }
    }
    
}
