//
//  ListProvinceResult.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/20/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import UIKit
import ObjectMapper

class ListProvinceResult: RestObject {

    var provinces: [Province]?
    
    override func mapping(map: Map) {
        provinces <- map["provinces"]
    }
    
}
