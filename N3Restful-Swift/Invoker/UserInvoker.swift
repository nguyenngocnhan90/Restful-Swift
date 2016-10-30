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
    
    func uploadAvatar(_ completion: @escaping (_ success: Bool, _ error: RESTError?) -> Void) {
        let request = requestWithMethodName("change_avatar")
        
        let image = UIImage(named: "my_avatar")
        let imageData = UIImageJPEGRepresentation(image!, 0.5)
        request.addFilePart("avatar", fileName: "avatar.jpg", data: imageData)
        request.addStringPart("access_token", string: "PvFxFyvcKrzLW3HF6FUV")
        
        request.POST_Multipart { (object, error) -> () in
            if error != nil {
                print(error)
                completion(false, error)
            }
            else {
                completion(true, nil)
            }
        }
    }
}
