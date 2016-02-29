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

