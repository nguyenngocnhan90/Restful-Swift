//
//  UserInvoker.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/26/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import UIKit

class UserInvoker: RESTInvoker {
    
    init() {
        super.init(controllerName: "users")
    }
    
    func uploadAvatar(_ completion: @escaping (_ success: Bool, _ error: RESTError?) -> Void) {
        if let request = createRequest(methodName: "change_avatar") {
            let image = UIImage(named: "my_avatar")
            let imageData = UIImageJPEGRepresentation(image!, 0.5)
            request.addFilePart("avatar", fileName: "avatar.jpg", data: imageData)
            request.addStringPart("access_token", string: "PvFxFyvcKrzLW3HF6FUV")
            
            request.postMultipart { (object, error) -> () in
                if error != nil {
                    print(error as Any)
                    completion(false, error)
                }
                else {
                    completion(true, nil)
                }
            }
        }
    }
}
