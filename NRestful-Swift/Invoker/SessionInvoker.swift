//
//  SessionInvoker.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/21/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import UIKit

class SessionInvoker: RestInvoker {
    
    init() {
        super.init(controllerName: "sessions")
    }
    
    func signIn(_ param: SignInParam, completion: @escaping (_ result: SignInResult?, _ error: RestError?) -> Void) {
        if let request = createRequest(methodName: nil) {
            request.post(bodyParam: param) { (result: SignInResult?, error) -> () in
                completion(result, error)
            }
        }
    }
    
    func signInFacebook(_ fbToken: String, completion: @escaping (_ result: SignInResult?, _ error: RestError?) -> Void) {
        if let request = createRequest(methodName: "fb") {
            let dictionary: [String: Any] = ["facebook_token": fbToken]
            
            request.request(dictionary: dictionary, method: .post) { (result: SignInResult?, error) -> () in
                completion(result, error)
            }
        }
    }
}
