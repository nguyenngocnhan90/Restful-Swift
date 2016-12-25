//
//  RESTRequest.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/19/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import HTTPStatusCodes
import Alamofire
import ObjectMapper

class RESTRequest: NSObject {
    
    var url: String!
    
    var parameters: [String: Any] = [:]
    var headers: [String: String] = [:]
    var multiparts: [RESTMultipart] = []
    
    init(url: String) {
        self.url = url
    }
    
    class func request(with url: String) -> RESTRequest {
        let request = RESTRequest(url: url)
        return request
    }
    
    // MARK: -
    // MARK: - Request methods
    
    /**
    GET request
     
     - parameter completion: callback result
     */
    open func get<T: RESTObject>(_ completion:@escaping (_ result: T?, _ error: RESTError?) -> ()) {
        appendQueryParamsToURL()
        
        Alamofire.request(url)
            .validate(statusCode: 200..<400)
            .responseJSON { response -> Void in
                
                switch response.result {
                case .success (let json):
                    guard let dictionary = json as? [String : Any],
                        let object = Mapper<T>().map(JSON: dictionary) else {
                        let restObj = RESTObject()
                        restObj.rawValue = "\(json)"
                        restObj.statusCode = HTTPStatusCode(rawValue: (response.response?.statusCode ?? 503))
                        
                        completion(restObj as? T, nil)
                        return
                    }
                    
                    object.statusCode = HTTPStatusCode(rawValue: (response.response?.statusCode ?? 503))
                    debugPrint(object)
                    completion(object, nil)
                    
                case .failure (let error):
                    let restError = RESTError(response: response, error: error)
                    debugPrint(restError.errorFromServer as Any)
                    completion(nil, restError)
                }
        }
    }
    
    open func getArray<T: RESTObject>(_ completion:@escaping (_ result: [T]?, _ error: RESTError?) -> ()) {
        appendQueryParamsToURL()
        
        Alamofire.request(url)
            .validate(statusCode: 200..<400)
            .responseJSON { response -> Void in
                
                switch response.result {
                case .success (let json):
                    let object = Mapper<T>().mapArray(JSONString: String(describing: json))
                    debugPrint(object as Any)
                    completion(object, nil)
                    
                case .failure (let error):
                    let restError = RESTError(response: response, error: error)
                    debugPrint(restError.errorFromServer as Any)
                    completion(nil, restError)
                }
        }
    }

    
    // MARK: - Request with object body
    
    /**
    POST request
    
    - parameter objectBody: object param - type RESTParam
    - parameter completion: callback result
    */
    open func post<T: RESTObject>(bodyParam param: RESTParam?, completion:@escaping (_ result: T?, _ error: RESTError?) -> ()) {
        request(bodyParam: param, method: .post) { (object: T?, error) -> () in
            completion(object, error)
        }
    }
    
    /**
     PUT request
     
     - parameter objectBody: object param - type RESTParam
     - parameter completion: callback result
     */
    open func put<T: RESTObject>(bodyParam param: RESTParam?, completion:@escaping (_ result: T?, _ error: RESTError?) -> ()) {
        request(bodyParam: param, method: .put) { (object: T?, error) -> () in
            completion(object, error)
        }
    }
    
    /**
     PATCH request
     
     - parameter objectBody: object param - type RESTParam
     - parameter completion: callback result
     */
    open func patch<T: RESTObject>(bodyParam param: RESTParam?, completion:@escaping (_ result: T?, _ error: RESTError?) -> ()) {
        request(bodyParam: param, method: .patch)
        { (object: T?, error) -> () in
            completion(object, error)
        }
    }

    /**
     DELETE request
     
     - parameter objectBody: object param - type RESTParam
     - parameter completion: callback result
     */
    open func delete<T: RESTObject>(bodyParam param: RESTParam?, completion:@escaping (_ result: T?, _ error: RESTError?) -> ()) {
        request(bodyParam: param, method: .delete) { (object: T?, error) -> () in
            completion(object, error)
        }
    }
    
    /**
     Common request with object oby
     
     - parameter objectBody: object param - type RESTParam
     - parameter method:
     - parameter completion: call back
     */
    fileprivate func request<T: RESTObject>(bodyParam objectBody: RESTParam?, method: Alamofire.HTTPMethod, completion:@escaping (_ result: T?, _ error: RESTError?) -> ()) {
        let dictionary = objectBody?.toDictionary()
        
        request(dictionary: dictionary, method: method) { (result: T?, error) -> () in
            completion(result, error)
        }
    }
    
    /**
     Request with dictionary parameters
     
     - parameter dictionaryParam: parameters
     - parameter method:          request method
     - parameter completion:      callback result
     */
    open func request<T: RESTObject>(dictionary param: [String: Any]?, method: Alamofire.HTTPMethod, completion:@escaping (_ result: T?, _ error: RESTError?) -> ()) {
        appendQueryParamsToURL()
        
        if let param = param {
            parameters = param
        }
        
        Alamofire.request(url,
            method: method,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: self.headers)
            .validate(statusCode: 200..<400)
            .responseJSON { (response) -> Void in
                
                switch response.result {
                case .success (let json):
                    guard let dictionary = json as? [String : Any],
                        let object = Mapper<T>().map(JSON: dictionary) else {
                        let restObj = RESTObject()
                        restObj.rawValue = "\(json)"
                        restObj.statusCode = HTTPStatusCode(rawValue: (response.response?.statusCode ?? 503))
                        
                        completion(restObj as? T, nil)
                        return
                    }
                    
                    object.statusCode = HTTPStatusCode(rawValue: (response.response?.statusCode ?? 503))
                    debugPrint(object)
                    completion(object, nil)
                    
                case .failure (let error):
                    let restError = RESTError(response: response, error: error)
                    debugPrint(restError.errorFromServer as Any)
                    completion(nil, restError)
                }
        }
    }
    
    open func requestArray<T: RESTObject>(dictionary param: [String: AnyObject]?, method: Alamofire.HTTPMethod, completion:@escaping (_ array: [T]?, _ error: RESTError?) -> ()) {
        appendQueryParamsToURL()
        
        if let param = param {
            self.parameters = param
        }
        
        Alamofire.request(url,
                          method: method,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: self.headers)
            .validate(statusCode: 200..<400)
            .responseJSON { (response) -> Void in
                
                switch response.result {
                case .success (let json):
                    let objects = Mapper<T>().mapArray(JSONString: String(describing: json))
                    debugPrint(objects as Any)
                    completion(objects, nil)
                    
                    
                case .failure (let error):
                    let restError = RESTError(response: response, error: error)
                    debugPrint(restError.errorFromServer as Any)
                    completion(nil, restError)
                }
        }
    }
    
    // MARK: - Multiparts: Uploading files
    
    /**
    POST request with multipart: file, data, string
    
    - parameter completion: callback result
    */
    open func postMultipart<T: RESTObject>(_ completion:@escaping (_ result: T?, _ error: RESTError?) -> ()) {
        upload(.post) { (object: T?, error) -> () in
            completion(object, error)
        }
    }
    
    /**
     PUT request with multipart: file, data, string
     
     - parameter completion: callback result
     */
    open func putMultipart<T: RESTObject>(_ completion:@escaping (_ result: T?, _ error: RESTError?) -> ()) {
        upload(.put) { (object: T?, error) -> () in
            completion(object, error)
        }
    }
    
    /**
     PATCH request with multipart: file, data, string
     
     - parameter completion: callback result
     */
    open func patchMultipart<T: RESTObject>(_ completion:@escaping (_ result: T?, _ error: RESTError?) -> ()) {
        upload(.patch) { (object: T?, error) -> () in
            completion(object, error)
        }
    }
    
    /**
     Upload multipart: file, data, string
     
     - parameter method:     POST, PUT, PATCH
     - parameter completion: callback result
     */
    fileprivate func upload<T: RESTObject>(_ method: Alamofire.HTTPMethod, completion:@escaping (_ result: T?, _ error: RESTError?) -> ()) {
        appendQueryParamsToURL()
        
        Alamofire.upload(
            multipartFormData: { (formData) -> Void in
                for part in self.multiparts {
                    formData.append(part.data,
                                    withName: part.contentDisposition,
                                    mimeType: part.contentType)
                }
            },
            to: url,
            method: method,
            encodingCompletion: { (result) -> Void in
                switch result {
                case .success(let request, _, _):
                    request
                        .validate(statusCode: 200..<400)
                        .responseJSON(completionHandler: { (response) -> Void in
                            print(response.result)
                            
                            switch response.result {
                            case .success (let json):
                                guard let dictionary = json as? [String : Any],
                                    let object = Mapper<T>().map(JSON: dictionary) else {
                                    let restObj = RESTObject()
                                    restObj.rawValue = "\(json)"
                                    restObj.statusCode = HTTPStatusCode(rawValue: (response.response?.statusCode ?? 503))
                                    
                                    completion(restObj as? T, nil)
                                    return
                                }
                                
                                object.statusCode = HTTPStatusCode(rawValue: (response.response?.statusCode ?? 503))
                                debugPrint(object)
                                completion(object, nil)
                                
                            case .failure (let error):
                                print(error)
                                
                                let restError = RESTError(response: response, error: error)
                                debugPrint(restError.errorFromServer as Any)
                                completion(nil, restError)
                            }
                        })
                    
                    break
                    
                case .failure(let error):
                    print(error)
                    
                    let restError = RESTError(error: error)
                    completion(nil, restError)
                    
                    break
                }
        })
    }
    
}


// MARK: -
// MARK: - Add Properties

extension RESTRequest {
    
    open func addObjectBodyParam(_ objectParam: RESTParam) {
        self.parameters = objectParam.toDictionary()
    }
    
    open func addQueryParam(_ name: String, value: AnyObject) {
        self.parameters[name] = "\(value)" as AnyObject?
    }
    
    open func addJsonPart(_ name: String, json: NSDictionary) {
        let part: RESTMultipart! = RESTMultipart.JSONPart(name: name, jsonObject: json)
        
        if part != nil {
            self.multiparts.append(part)
        }
    }
    
    open func addFilePart(_ name: String, fileName: String, data: Data!) {
        let part: RESTMultipart! = RESTMultipart.FilePart(name: name, fileName: fileName, data: data)
        
        if part != nil {
            self.multiparts.append(part)
        }
    }
    
    open func addStringPart(_ name: String, string: String) {
        let part: RESTMultipart! = RESTMultipart.StringPart(name: name, string: string)
        
        if part != nil {
            self.multiparts.append(part)
        }
    }
    
}

// MARK: - Set header, content type, accept, authorization

extension RESTRequest {
    
    open func addHeader(_ name: String, value: AnyObject) {
        headers[name] = value as? String
    }
    
    open func setContentType(_ contentType: String) {
        headers[RESTContant.kRESTRequestContentTypeKey] = contentType
    }
    
    open func setAccept(_ accept: String) {
        self.headers[RESTContant.kRESTRequestAcceptKey] = accept
    }
    
    open func setAuthorization(_ authorization: String) {
        self.headers[RESTContant.kRESTRequestAuthorizationKey] = authorization
    }
    
}

extension RESTRequest {
    
    fileprivate func appendQueryParamsToURL() {
        var query: String = ""
        
        for (key, value) in self.parameters {
            if (query.lengthOfBytes(using: String.Encoding.utf8) == 0) {
                query = "?"
            }
            else {
                query += "&"
            }
            
            query = query + key + "=" + (value as! String)
        }
        
        url = url + query
    }
    
}

