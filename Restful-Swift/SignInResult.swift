//
//  SignInResult.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/26/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import UIKit
import ObjectMapper

class SignInResult: RestObject {
    var access_token: String?
    var user: User?
    
    override func mapping(map: Map) {
        access_token <- map["access_token"]
        user <- map["user"]
        
    }
}
