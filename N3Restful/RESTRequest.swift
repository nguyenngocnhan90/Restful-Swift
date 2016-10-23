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
    
    class func requestWithURL(_ url: String) -> RESTRequest {
        let request = RESTRequest(url: url)
        return request
    }
    
    // MARK: -
    // MARK: - Request methods
    
    /**
    GET request
     
     - parameter completion: callback result
     */
    func GET<T: RESTObject>(_ completion:@escaping (_ result: T?, _ error: RESTError?) -> ()) {
        appendQueryParamsToURL()
        
        Alamofire.request(url)
            .validate(statusCode: 200..<400)
            .responseJSON { response -> Void in
                
                switch response.result {
                case .success (let json):
                    guard let object = Mapper<T>().map(JSON: json as! [String : Any]) else {
                        let restObj = RESTObject()
                        restObj.rawValue = "\(json)"
                        restObj.statusCode = (response.response?.statusCode)!
                        
                        completion(restObj as? T, nil)
                        return
                    }
                    
                    object.statusCode = (response.response?.statusCode)!
                    debugPrint(object)
                    completion(object, nil)
                    
                case .failure (let error):
                    let restError = RESTError(responseData: response.data, error: error)
                    debugPrint(restError.errorFromServer)
                    completion(nil, restError)
                }
        }
    }
    
    func GETArray<T: RESTObject>(_ completion:@escaping (_ result: [T]?, _ error: RESTError?) -> ()) {
        appendQueryParamsToURL()
        
        Alamofire.request(url)
            .validate(statusCode: 200..<400)
            .responseJSON { response -> Void in
                
                switch response.result {
                case .success (let json):
                    let object = Mapper<T>().mapArray(JSONString: String(describing: json))
                    debugPrint(object)
                    completion(object, nil)
                    
                case .failure (let error):
                    let restError = RESTError(responseData: response.data, error: error)
                    debugPrint(restError.errorFromServer)
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
    func POST<T: RESTObject>(_ objectBody: RESTParam!, completion:@escaping (_ result: T?, _ error: RESTError?) -> ()) {
        requestWithObjectBody(objectBody, method: .post) { (object: T?, error) -> () in
            completion(object, error)
        }
    }
    
    /**
     PUT request
     
     - parameter objectBody: object param - type RESTParam
     - parameter completion: callback result
     */
    func PUT<T: RESTObject>(_ objectBody: RESTParam!, completion:@escaping (_ result: T?, _ error: RESTError?) -> ()) {
        requestWithObjectBody(objectBody, method: .put) { (object: T?, error) -> () in
            completion(object, error)
        }
    }
    
    /**
     PATCH request
     
     - parameter objectBody: object param - type RESTParam
     - parameter completion: callback result
     */
    func PATCH<T: RESTObject>(_ objectBody: RESTParam!, completion:@escaping (_ result: T?, _ error: RESTError?) -> ()) {
        requestWithObjectBody(objectBody, method: .patch)
        { (object: T?, error) -> () in
            completion(object, error)
        }
    }

    /**
     DELETE request
     
     - parameter objectBody: object param - type RESTParam
     - parameter completion: callback result
     */
    func DELETE<T: RESTObject>(_ objectBody: RESTParam!, completion:@escaping (_ result: T?, _ error: RESTError?) -> ()) {
        requestWithObjectBody(objectBody, method: .delete) { (object: T?, error) -> () in
            completion(object, error)
        }
    }
    
    /**
     Common request with object oby
     
     - parameter objectBody: object param - type RESTParam
     - parameter method:
     - parameter completion: call back
     */
    fileprivate func requestWithObjectBody<T: RESTObject>(_ objectBody: RESTParam?, method: Alamofire.HTTPMethod, completion:@escaping (_ result: T?, _ error: RESTError?) -> ()) {
        let dictionary = objectBody?.toDictionary()
        
        requestWithDictionary(dictionary, method: method) { (result: T?, error) -> () in
            completion(result, error)
        }
    }
    
    /**
     Request with dictionary parameters
     
     - parameter dictionaryParam: parameters
     - parameter method:          request method
     - parameter completion:      callback result
     */
    func requestWithDictionary<T: RESTObject>(_ dictionaryParam: [String: AnyObject]?, method: Alamofire.HTTPMethod, completion:@escaping (_ result: T?, _ error: RESTError?) -> ()) {
        appendQueryParamsToURL()
        
        if let dictionaryParam = dictionaryParam {
            self.parameters = dictionaryParam
        }
        
        Alamofire.request(
            url,
            method,
            parameters: self.parameters,
            encoding: ParameterEncoding.JSON,
            headers: self.headers)
            .validate(statusCode: 200..<400)
            .responseJSON { (response) -> Void in
                
                switch response.result {
                case .success (let json):
                    guard let object = Mapper<T>().map(JSON: json) else {
                        let restObj = RESTObject()
                        restObj.rawValue = "\(json)"
                        restObj.statusCode = (response.response?.statusCode)!
                        
                        completion(result: restObj as? T, error: nil)
                        return
                    }
                    
                    object.statusCode = (response.response?.statusCode)!
                    debugPrint(object)
                    completion(result: object, error: nil)
                    
                case .failure (let error):
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
    func POST_Multipart<T: RESTObject>(_ completion:@escaping (_ result: T?, _ error: RESTError?) -> ()) {
        upload(.post) { (object: T?, error) -> () in
            completion(object, error)
        }
    }
    
    /**
     PUT request with multipart: file, data, string
     
     - parameter completion: callback result
     */
    func PUT_Multipart<T: RESTObject>(_ completion:@escaping (_ result: T?, _ error: RESTError?) -> ()) {
        upload(.put) { (object: T?, error) -> () in
            completion(object, error)
        }

    }
    
    /**
     PATCH request with multipart: file, data, string
     
     - parameter completion: callback result
     */
    func PATCH_Multipart<T: RESTObject>(_ completion:@escaping (_ result: T?, _ error: RESTError?) -> ()) {
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
                                guard let object = Mapper<T>().map(JSON: json as! [String : Any]) else {
                                    let restObj = RESTObject()
                                    restObj.rawValue = "\(json)"
                                    restObj.statusCode = (response.response?.statusCode)!
                                    
                                    completion(restObj as? T, nil)
                                    return
                                }
                                
                                object.statusCode = (response.response?.statusCode)!
                                debugPrint(object)
                                completion(object, nil)
                                
                            case .failure (let error):
                                print(error)
                                
                                let restError = RESTError(responseData: response.data, error: error)
                                debugPrint(restError.errorFromServer)
                                completion(nil, restError)
                            }
                        })
                    
                    break
                    
                case .failure(let error):
                    print(error)
                    
                    let restError = RESTError(errorType: error)
                    completion(nil, restError)
                    
                    break
                }
        })
    }
    
}


// MARK: -
// MARK: - Add Properties

extension RESTRequest {
    
    func addObjectBodyParam(_ objectParam: RESTParam) {
        self.parameters = objectParam.toDictionary()
    }
    
    func addQueryParam(_ name: String, value: AnyObject) {
        self.parameters[name] = "\(value)" as AnyObject?
    }
    
    func addJsonPart(_ name: String!, json: NSDictionary!) {
        let part: RESTMultipart! = RESTMultipart.JSONPart(name: name, jsonObject: json)
        
        if part != nil {
            self.multiparts.append(part)
        }
    }
    
    func addFilePart(_ name: String!, fileName: String!, data: Data!) {
        let part: RESTMultipart! = RESTMultipart.FilePart(name: name, fileName: fileName, data: data)
        
        if part != nil {
            self.multiparts.append(part)
        }
    }
    
    func addStringPart(_ name: String!, string: String!) {
        let part: RESTMultipart! = RESTMultipart.StringPart(name: name, string: string)
        
        if part != nil {
            self.multiparts.append(part)
        }
    }
    
}

// MARK: - Set header, content type, accept, authorization

extension RESTRequest {
    
    func addHeader(_ name: String, value: AnyObject) {
        headers[name] = value as? String
    }
    
    func setContentType(_ contentType: String) {
        headers[RESTContants.kRESTRequestContentTypeKey] = contentType
    }
    
    func setAccept(_ accept: String) {
        self.headers[RESTContants.kRESTRequestAcceptKey] = accept
    }
    
    func setAuthorization(_ authorization: String) {
        self.headers[RESTContants.kRESTRequestAuthorizationKey] = authorization
    }
    
}

extension RESTRequest {
    
    func appendQueryParamsToURL() {
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

