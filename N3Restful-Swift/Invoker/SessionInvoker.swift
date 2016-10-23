//
//  SessionInvoker.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/21/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import UIKit

class SessionInvoker: BaseInvoker {
    
    init() {
        super.init(controllerName: "sessions")
    }
    
    func signIn(_ param: SignInParam, completion: @escaping (_ result: SignInResult?, _ error: RESTError?) -> Void) {
        let request = requestWithMethodName(nil)
        
        request.POST(param) { (result: SignInResult?, error) -> () in
            completion(result, error)
        }
    }
    
    func signInFacebook(_ fbToken: String, completion: @escaping (_ result: SignInResult?, _ error: RESTError?) -> Void) {
        let request = requestWithMethodName("facebook")
        let dictionary = ["facebook_token": fbToken]
        
        request.requestWithDictionary(dictionary as [String : AnyObject]!, method: .post) { (result: SignInResult?, error) -> () in
            completion(result, error)
        }
    }
}
