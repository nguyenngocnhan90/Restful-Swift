//
//  UserInvoker.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/26/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import UIKit

class UserInvoker: BaseInvoker {

    init() {
        super.init(controllerName: "users")
    }
    
    func uploadAvatar(completion: (success: Bool, error: RESTError?) -> Void) {
        let request = requestWithMethodName("update_avatar")
        
        let image = UIImage(named: "my_avatar")
        let imageData = UIImageJPEGRepresentation(image!, 0.5)
        request.addFilePart("avatar", fileName: "avatar.jpg", data: imageData)
        request.addStringPart("access_token", string: "user_access_token")
        
        request.POST_Multipart { (object, error) -> () in
            if error != nil {
                print(error)
                completion(success: false, error: error)
            }
            else {
                completion(success: true, error: nil)
            }
        }
    }
}
