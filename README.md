## N3Restful-Swift

RESTful service interaction in iOS project with Swift.

- Create request with [Alamofire](https://github.com/Alamofire/Alamofire).
- Return JSON with [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON).
- Parse JSON to Swift object automacally with [ROJSONParser](https://github.com/prine/ROJSONParser).


## Features

- Request with dictionary param.
- Request with object param [RESTParam](https://github.com/nguyenngocnhan90/N3Restful-Swift/blob/master/N3Restful/RESTParam.swift).
- Request with multipart data (JSON, String, File).


## Installation

- Embedded frameworks require a minimum deployment target of iOS 8.
- Copy 'N3Restful' folder to your project manually. 
- Install [Alamofire](https://github.com/Alamofire/Alamofire) and [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:
```bash
$ gem install cocoapods
```

To integrate Alamofire and SwiftyJSON into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Alamofire'
pod 'SwiftyJSON'
```

Then, run the following command:

```bash
$ pod install
```

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate Alamofire and SwwiftyJSON into your project manually.


## Usage

### Create data model `SignInResult`

```swift
class SignInResult: ROJSONObject {
    var access_token: String! {
        return Value<String>.get(self, key: "access_token")
    }
    
    lazy var user: User! = {
        return Value<User>.getROJSONOject(self, key: "user")
    }()
}
```
```swift
class User: ROJSONObject {

    var email: String! {
        return Value<String>.get(self, key: "email")
    }
    
    var first_name: String! {
        return Value<String>.get(self, key: "first_name")
    }
    
    var last_name: String! {
        return Value<String>.get(self, key: "last_name")
    }
}
```

### Create object param class 

```swift
  class SignInParam: RESTParam {
    var email: String!
    var password: String!
  }
```

### Invoker

- Init invoker with a controller:
```swift
    init() {
        super.init(controllerName: "sessions")
    }
```

- Make a request to sign in and parse response to `SignInResult` object
```swift
    func signIn(param: SignInParam, completion: (result: SignInResult?, error: RESTError?) -> Void) {
        let request = requestWithMethodName(nil)
        
        request.POST(param) { (result: SignInResult?, error) -> () in
            completion(result: result, error: error)
        }
    }
```
