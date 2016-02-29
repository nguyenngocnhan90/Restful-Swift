//
//  District.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/19/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import UIKit

class District: ROJSONObject {
    var id: Int {
        return Value<Int>.get(self, key: "id")
    }
    
    var province_id: Int {
        return Value<Int>.get(self, key: "province_id")
    }
    
    var name: String! {
        return Value<String>.get(self, key: "name")
    }

    var full_name: String! {
        return Value<String>.get(self, key: "full_name")
    }

    var unit: String! {
        return Value<String>.get(self, key: "unit")
    }

    required init() {
        super.init()
    }
    
    required init(jsonData: AnyObject) {
        super.init(jsonData: jsonData)
    }
    
    required init(jsonString: String) {
        super.init(jsonString: jsonString)
    }
}
