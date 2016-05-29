//
//  RESTRequest.swift
//  N3Restful-Swift
//
//  Created by Nhan Nguyen on 2/19/16.
//  Copyright © 2016 Nhan Nguyen. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class RESTRequest: NSObject {
    
    var url: String!
    
    var parameters: [String: AnyObject] = [:]
    var headers: [String: String] = [:]
    var multiparts: [RESTMultipart] = []
    
    init(url: String) {
        self.url = url
    }
    
    class func requestWithURL(url: String) -> RESTRequest {
        let request = RESTRequest(url: url)
        return request
    }
    
    // MARK: -
    // MARK: - Request methods
    
    /**
    GET request
     
     - parameter completion: callback result
     */
    func GET<T: RESTObject>(completion:(result: T?, error: RESTError?) -> ()) {
        appendQueryParamsToURL()
        
        Alamofire.request(.GET, url)
            .validate(statusCode: 200..<400)
            .responseJSON { response -> Void in
                
                switch response.result {
                case .Success (let json):
                    guard let object = Mapper<T>().map(json) else {
                        let restObj = RESTObject()
                        restObj.rawValue = "\(json)"
                        restObj.statusCode = (response.response?.statusCode)!
                        
                        completion(result: restObj as? T, error: nil)
                        return
                    }
                    
                    object.statusCode = (response.response?.statusCode)!
                    debugPrint(object)
                    completion(result: object, error: nil)
                    
                case .Failure (let error):
                    let restError = RESTError(responseData: response.data, error: error)
                    debugPrint(restError.errorFromServer)
                    completion(result: nil, error: restError)
                }
        }
    }
    
    func GETArray<T: RESTObject>(completion:(result: [T]?, error: RESTError?) -> ()) {
        appendQueryParamsToURL()
        
        Alamofire.request(.GET, url)
            .validate(statusCode: 200..<400)
            .responseJSON { response -> Void in
                
                switch response.result {
                case .Success (let json):
                    let object = Mapper<T>().mapArray(json)
                    debugPrint(object)
                    completion(result: object, error: nil)
                    
                case .Failure (let error):
                    let restError = RESTError(responseData: response.data, error: error)
                    debugPrint(restError.errorFromServer)
                    completion(result: nil, error: restError)
                }
        }
    }

    
    // MARK: - Request with object body
    
    /**
    POST request
    
    - parameter objectBody: object param - type RESTParam
    - parameter completion: callback result
    */
    func POST<T: RESTObject>(objectBody: RESTParam!, completion:(result: T?, error: RESTError?) -> ()) {
        requestWithObjectBody(objectBody, method: .POST) { (object: T?, error) -> () in
            completion(result: object, error: error)
        }
    }
    
    /**
     PUT request
     
     - parameter objectBody: object param - type RESTParam
     - parameter completion: callback result
     */
    func PUT<T: RESTObject>(objectBody: RESTParam!, completion:(result: T?, error: RESTError?) -> ()) {
        requestWithObjectBody(objectBody, method: .PUT) { (object: T?, error) -> () in
            completion(result: object, error: error)
        }
    }
    
    /**
     PATCH request
     
     - parameter objectBody: object param - type RESTParam
     - parameter completion: callback result
     */
    func PATCH<T: RESTObject>(objectBody: RESTParam!, completion:(result: T?, error: RESTError?) -> ()) {
        requestWithObjectBody(objectBody, method: .PATCH) { (object: T?, error) -> () in
            completion(result: object, error: error)
        }
    }

    /**
     DELETE request
     
     - parameter objectBody: object param - type RESTParam
     - parameter completion: callback result
     */
    func DELETE<T: RESTObject>(objectBody: RESTParam!, completion:(result: T?, error: RESTError?) -> ()) {
        requestWithObjectBody(objectBody, method: .DELETE) { (object: T?, error) -> () in
            completion(result: object, error: error)
        }
    }
    
    /**
     Common request with object oby
     
     - parameter objectBody: object param - type RESTParam
     - parameter method:
     - parameter completion: call back
     */
    private func requestWithObjectBody<T: RESTObject>(objectBody: RESTParam!, method: Alamofire.Method, completion:(result: T?, error: RESTError?) -> ()) {
        let dictionary = objectBody?.toDictionary()
        
        requestWithDictionary(dictionary, method: method) { (result: T?, error) -> () in
            completion(result: result, error: error)
        }
    }
    
    /**
     Request with dictionary parameters
     
     - parameter dictionaryParam: parameters
     - parameter method:          request method
     - parameter completion:      callback result
     */
    func requestWithDictionary<T: RESTObject>(dictionaryParam: [String: AnyObject]!, method: Alamofire.Method, completion:(result: T?, error: RESTError?) -> ()) {
        appendQueryParamsToURL()
        
        if dictionaryParam != nil {
            self.parameters = dictionaryParam
        }
        
        Alamofire.request(
            method,
            url,
            parameters: self.parameters,
            encoding: ParameterEncoding.JSON,
            headers: self.headers)
            .validate(statusCode: 200..<400)
            .responseJSON { (response) -> Void in
                
                switch response.result {
                case .Success (let json):
                    guard let object = Mapper<T>().map(json) else {
                        let restObj = RESTObject()
                        restObj.rawValue = "\(json)"
                        restObj.statusCode = (response.response?.statusCode)!
                        
                        completion(result: restObj as? T, error: nil)
                        return
                    }
                    
                    object.statusCode = (response.response?.statusCode)!
                    debugPrint(object)
                    completion(result: object, error: nil)
                    
                case .Failure (let error):
                    let restError = RESTError(responseData: response.data, error: error)
                    debugPrint(restError.errorFromServer)
                    completion(result: nil, error: restError)
                }
        }
    }
    
    // MARK: - Multiparts: Uploading files
    
    /**
    POST request with multipart: file, data, string
    
    - parameter completion: callback result
    */
    func POST_Multipart<T: RESTObject>(completion:(result: T?, error: RESTError?) -> ()) {
        upload(.POST) { (object: T?, error) -> () in
            completion(result: object, error: error)
        }
    }
    
    /**
     PUT request with multipart: file, data, string
     
     - parameter completion: callback result
     */
    func PUT_Multipart<T: RESTObject>(completion:(result: T?, error: RESTError?) -> ()) {
        upload(.PUT) { (object: T?, error) -> () in
            completion(result: object, error: error)
        }

    }
    
    /**
     PATCH request with multipart: file, data, string
     
     - parameter completion: callback result
     */
    func PATCH_Multipart<T: RESTObject>(completion:(result: T?, error: RESTError?) -> ()) {
        upload(.PATCH) { (object: T?, error) -> () in
            completion(result: object, error: error)
        }
    }
    
    /**
     Upload multipart: file, data, string
     
     - parameter method:     POST, PUT, PATCH
     - parameter completion: callback result
     */
    private func upload<T: RESTObject>(method: Alamofire.Method, completion:(result: T?, error: RESTError?) -> ()) {
        appendQueryParamsToURL()
        
        Alamofire.upload(
            method,
            url,
            multipartFormData: { (formData) -> Void in
                for part in self.multiparts {
                    formData.appendBodyPart(
                        data: part.data,
                        name: part.contentDisposition,
                        mimeType: part.contentType
                    )
                }
            })
            { (result) -> Void in
                switch result {
                case .Success(let request, _, _):
                    request
                        .validate(statusCode: 200..<400)
                        .responseJSON(completionHandler: { (response) -> Void in
                        print(response.result)
                        
                        switch response.result {
                        case .Success (let json):
                            guard let object = Mapper<T>().map(json) else {
                                let restObj = RESTObject()
                                restObj.rawValue = "\(json)"
                                restObj.statusCode = (response.response?.statusCode)!
                                
                                completion(result: restObj as? T, error: nil)
                                return
                            }
                            
                            object.statusCode = (response.response?.statusCode)!
                            debugPrint(object)
                            completion(result: object, error: nil)
                            
                        case .Failure (let error):
                            print(error)
                            
                            let restError = RESTError(responseData: response.data, error: error)
                            debugPrint(restError.errorFromServer)
                            completion(result: nil, error: restError)
                        }
                    })
                    
                    break
                    
                case .Failure(let error):
                    print(error)
                    
                    let restError = RESTError(errorType: error)
                    completion(result: nil, error: restError)
                    
                    break
                }
        }
    }
    
}


// MARK: -
// MARK: - Add Properties

extension RESTRequest {
    
    func addObjectBodyParam(objectParam: RESTParam) {
        self.parameters = objectParam.toDictionary()
    }
    
    func addQueryParam(name: String, value: AnyObject) {
        self.parameters[name] = "\(value)"
    }
    
    func addJsonPart(name: String!, json: NSDictionary!) {
        let part: RESTMultipart! = RESTMultipart.JSONPart(name: name, jsonObject: json)
        
        if part != nil {
            self.multiparts.append(part)
        }
    }
    
    func addFilePart(name: String!, fileName: String!, data: NSData!) {
        let part: RESTMultipart! = RESTMultipart.FilePart(name: name, fileName: fileName, data: data)
        
        if part != nil {
            self.multiparts.append(part)
        }
    }
    
    func addStringPart(name: String!, string: String!) {
        let part: RESTMultipart! = RESTMultipart.StringPart(name: name, string: string)
        
        if part != nil {
            self.multiparts.append(part)
        }
    }
    
}

// MARK: - Set header, content type, accept, authorization

extension RESTRequest {
    
    func addHeader(name: String, value: AnyObject) {
        headers[name] = value as? String
    }
    
    func setContentType(contentType: String) {
        headers[RESTContants.kRESTRequestContentTypeKey] = contentType
    }
    
    func setAccept(accept: String) {
        self.headers[RESTContants.kRESTRequestAcceptKey] = accept
    }
    
    func setAuthorization(authorization: String) {
        self.headers[RESTContants.kRESTRequestAuthorizationKey] = authorization
    }
    
}

extension RESTRequest {
    
    func appendQueryParamsToURL() {
        var query: String = ""
        
        for (key, value) in self.parameters {
            if (query.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0) {
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

