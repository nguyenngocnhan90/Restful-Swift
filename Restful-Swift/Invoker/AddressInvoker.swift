//
//  AddressInvoker.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/19/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import Foundation

class AddressInvoker: RestInvoker {
    
    init() {
        super.init(controllerName: "addresses")
    }
    
    func getListAddress(_ completion: @escaping (_ listProvinces: ListProvinceResult?, _ error: RestError?) -> Void) {
        if let request = createRequest() {
            request.addQueryParam("updated_at", value: "\(0)" as AnyObject)
            
            request.get { (object: ListProvinceResult?, error) -> () in
                completion(object, error)
            }
        }
    }
}
