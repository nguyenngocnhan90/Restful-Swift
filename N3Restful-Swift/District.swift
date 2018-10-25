//
//  District.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/19/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import UIKit
import ObjectMapper

class District: RestObject {
    
    var id: Int = 0
    var province_id: Int = 0
    
    var name: String = ""
    var full_name: String = ""
    var unit: String = ""
    
    override func mapping(map: Map) {
        
        id <- map["id"]
        province_id <- map["province_id"]
        
        name <- map["name"]
        full_name <- map["full_name"]
        unit <- map["unit"]
    }
    
}
