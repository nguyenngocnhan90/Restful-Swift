//
//  RESTMultipart.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/19/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import Foundation

class RestMultipart: NSObject {
    
    var name: String = ""
    var contentType: String = ""
    var contentDisposition: String = ""
    var data: Data!
    var fileName: String = ""
    
    init(name: String, contentType: String, data: Data) {
        self.name = name
        self.contentType = contentType
        self.contentDisposition = "form-data; name=" + self.name
        
        self.data = data
    }
    
    class JSONPart: RestMultipart {
        
        init(name: String, jsonObject: NSObject) {
            let data: Data! = NSKeyedArchiver.archivedData(
                withRootObject: (jsonObject as! RestParam).toDictionary
            )
            super.init(name: name, contentType: "application/json", data: data)
        }
        
    }
    
    class FilePart: RestMultipart {
        
        init(name: String, fileName: String, data: Data) {
            super.init(name: name, contentType: "image/png/jpg/jpeg", data: data)
            
            self.fileName = fileName
            self.contentDisposition = "form-data; name=\"" + self.name
                + "\"; filename=\"" + self.fileName + "\""
        }
        
    }
    
    class StringPart: RestMultipart {
        
        init(name: String, string: String) {
            let data: Data! = string.data(using: String.Encoding.utf8)
            super.init(name: name, contentType: "application/json", data: data)
        }
        
    }
    
}
