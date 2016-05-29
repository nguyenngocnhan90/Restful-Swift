//
//  Province.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/19/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import UIKit
import ObjectMapper

class Province: RESTObject {
    
    var id: Int = 0
    
    var name: String = ""
    var full_name: String = ""
    var unit: String = ""
    var districts: [District]?
    
    override func mapping(map: Map) {
        id <- map["id"]
        
        name <- map["name"]
        full_name <- map["full_name"]
        unit <- map["unit"]
        districts <- map["districts"]
    }
    
}
