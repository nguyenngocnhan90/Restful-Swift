//
//  User.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/26/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import UIKit

class User: RESTObject {

    var email: String! {
        return Value<String>.get(self, key: "email")
    }
    
    var first_name: String! {
        return Value<String>.get(self, key: "first_name")
    }
    
    var last_name: String! {
        return Value<String>.get(self, key: "last_name")
    }
}
