//
//  AddressInvoker.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/19/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import Foundation

class AddressInvoker: BaseInvoker {
    
    init() {
        super.init(controllerName: "addresses")
    }

    func getListAddress(completion: (listProvinces: ListProvinceResult?, error: RESTError?) -> Void) {
        let request = requestWithMethodName(nil)
        request.addQueryParam("updated_at", value: "\(0)")
        
        request.GET { (object: ListProvinceResult?, error) -> () in
            completion(listProvinces: object, error: error)
        }
    }
}
