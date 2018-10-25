//
//  User.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/26/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import UIKit
import ObjectMapper

class User: RestObject {

    var email: String = ""
    var first_name: String = ""
    var last_name: String = ""
    
    
    override func mapping(map: Map) {
        
        email <- map["email"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
    }
    
}
