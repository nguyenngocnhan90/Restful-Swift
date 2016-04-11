//
//  ListProvinceResult.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/20/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import UIKit

class ListProvinceResult: RESTObject {

    lazy var provinces: [Province] = {
        return Value<[Province]>.getArray(self, key: "provinces")
    }()
}
