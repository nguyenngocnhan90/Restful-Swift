//
//  SignInResult.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/26/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import UIKit

class SignInResult: ROJSONObject {
    var access_token: String! {
        return Value<String>.get(self, key: "access_token")
    }
    
    lazy var user: User! = {
        return Value<User>.getROJSONOject(self, key: "user")
    }()
}
