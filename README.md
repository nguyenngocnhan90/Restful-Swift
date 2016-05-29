## N3Restful-Swift

RESTful service interaction in Swift iOS project.

- Create request with [Alamofire](https://github.com/Alamofire/Alamofire).
- Return JSON with [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON).
- Parse JSON to Swift object automacally with [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper).


## Features

- Request with dictionary param.
- Request with object param [RESTParam](https://github.com/nguyenngocnhan90/N3Restful-Swift/blob/master/N3Restful/RESTParam.swift).
- Request with multipart data (JSON, String, File).

## Requirements

- iOS 8.0 or later.

## Installation

- Copy [`N3Restful`](https://github.com/nguyenngocnhan90/N3Restful-Swift/tree/master/N3Restful) folder to your project manually. 
- Install [Alamofire](https://github.com/Alamofire/Alamofire), [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) and [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper).

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
pod 'ObjectMapper'
```

Then, run the following command:

```bash
$ pod install
```

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate Alamofire and SwwiftyJSON into your project manually.

## How to map JSON to Object

### Map normal data type: Int, Float, Double, String...

```swift
var email: String! {
    return Value<String>.get(self, key: "email")
}
```

### Map ROJSONObject

```swift
lazy var user: User! = {
    return Value<User>.getROJSONOject(self, key: "user")
}()
```

### Map Array of Objects

```swift
lazy var users: [User] = {
    return Value<[User]>.getArray(self, key: "users")
}()
```

## Usage

### Create data model `SignInResult`

```swift
class SignInResult: ROJSONObject {
    var access_token: String?
    var user: User?
    
    override func mapping(map: Map) {
        access_token <- map["access_token"]
        user <- map["user"]
    }
}
```
```swift
class User: ROJSONObject {

    var email: String = ""
    var first_name: String = ""
    var last_name: String = ""
    
    
    override func mapping(map: Map) {
        
        email <- map["email"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
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

## Contribution

If you see any problems or you want to make an improvement, please create [Issues](https://github.com/nguyenngocnhan90/N3Restful-Swift/issues) ans we can discuss.

Thanks
