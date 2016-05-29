//
//  Serializable.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/19/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import Foundation

class RESTParam: NSObject {
    
    func toDictionary() -> [String: AnyObject] {
        // make dictionary
        var dict = [String: AnyObject]()
        
        // add values
        for prop in self.propertyNames() {
            let val = self.valueForKey(prop)
            
            if (val is String)
            {
                dict[prop] = val as! String
            }
            else if (val is Int)
            {
                dict[prop] = val as! Int
            }
            else if (val is Double)
            {
                dict[prop] = val as! Double
            }
            else if (val is Array<String>)
            {
                dict[prop] = val as! Array<String>
            }
            else if (val is RESTParam)
            {
                dict[prop] = val?.toDictionary()
            }
            else if (val is Array<RESTParam>)
            {
                var arr = Array<[String: AnyObject]>()
                
                for item in (val as! Array<RESTParam>) {
                    arr.append(item.toDictionary())
                }
                
                dict[prop] = arr
            }
        }
        
        // return dict
        return dict
    }
    
    func toJSON() -> String? {
        // get dict
        let dict = toDictionary()
        
        // make JSON
        var error:NSError? = nil
        var data: NSData? = nil
        
        do {
            try data = NSJSONSerialization.dataWithJSONObject(dict, options:NSJSONWritingOptions(rawValue: 0))
        }
        catch let err as NSError {
            error = err
        }
        
        if error != nil {
            return nil
        }
        
        // return result
        return String(data: data!, encoding: NSUTF8StringEncoding)
    }
    
}

extension NSObject {
    
    func propertyNames() -> [String] {
        var results: [String] = []
        
        // retrieve the properties via the class_copyPropertyList function
        var count: UInt32 = 0
        let myClass: AnyClass = self.classForCoder
        let properties = class_copyPropertyList(myClass, &count)
        
        // iterate each objc_property_t struct
        for i in 0..<count {
            let property = properties[Int(i)]
            
            // retrieve the property name by calling property_getName function
            let cname = property_getName(property)
            
            // covert the c string into a Swift string
            let name = String.fromCString(cname)
            results.append(name!)
        }
        
        // release objc_property_t structs
        free(properties)
        
        return results
    }
    
}
