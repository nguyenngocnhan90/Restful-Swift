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

class RestRequest: NSObject {
    
    var url: String = ""
    
    var queryParameters: [String: Any] = [:]
    var parameters: [String: Any] = [:]
    var headers: [String: String] = [:]
    var multiparts: [RestMultipart] = []
    
    // MARK: - Manager
    
    fileprivate lazy var sessionManager: SessionManager = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = RestContant.requestTimeOut
        
        let manager = Alamofire.SessionManager(configuration: config)
        return manager
    }()
    
    // MARK: - Initial
    
    init(url: String) {
        self.url = url
    }
    
    static func request(with url: String) -> RestRequest {
        let request = RestRequest(url: url)
        return request
    }
    
    // MARK: - Completions
    
    typealias ObjectCompletion<T: RestObject> = (_ result: T?, _ error: RestError?) -> ()
    typealias ArrayCompletion<T: RestObject> = (_ result: [T], _ error: RestError?) -> ()
    
}

// MARK: - BASE REQUEST

extension RestRequest {
    
    fileprivate func dataRequest(method: Alamofire.HTTPMethod = .get, encoding: ParameterEncoding = URLEncoding.default) -> DataRequest {
        appendQueryParamsToURL()
        return sessionManager.request(url,
                                      method: method,
                                      parameters: parameters,
                                      encoding: encoding,
                                      headers: headers)
            .validate(statusCode: 200..<400)
    }
    
    fileprivate func handleResponse<T: RestObject>(_ response: DataResponse<Any>,
                                                   _ completion: ObjectCompletion<T>? = nil,
                                                   retry: (() -> Void)? = nil) {
        let statusCode = HTTPStatusCode(rawValue: (response.response?.statusCode ?? 503))!
        
        switch response.result {
        case .success (let json):
            guard let dictionary = json as? [String : Any],
                let object = Mapper<T>().map(JSON: dictionary) else {
                    let restObj = RestObject()
                    restObj.rawValue = "\(json)"
                    restObj.statusCode = statusCode
                    
                    completion?(restObj as? T, nil)
                    return
            }
            
            object.statusCode = statusCode
            debugPrint(object)
            completion?(object, nil)
            
        case .failure (let error):
            let restError = RestError(response: response, error: error)
            debugPrint(restError.errorMessage ?? "")
            
            var restObject: RestObject?
            if let json = restError.responseDictionary {
                restObject = Mapper<T>().map(JSON: json)
            }
            
            completion?(restObject as? T, restError)
        }
    }
    
    func handleArrayResponse<T: RestObject>(_ response: DataResponse<Any>,
                                            _ completion: ArrayCompletion<T>?,
                                            retry: (() -> Void)? = nil) {
        switch response.result {
        case .success (let json):
            guard let jsonArr = json as? [[String: Any]] else {
                completion?([], nil)
                return
            }
            
            let objects = Mapper<T>().mapArray(JSONArray: jsonArr)
            debugPrint(objects as Any)
            completion?(objects, nil)
            
        case .failure (let error):
            let restError = RestError(response: response, error: error)
            debugPrint(restError.errorMessage ?? "")
            
            completion?([], restError)
        }
    }
    
}

// MARK: - GET

extension RestRequest {
    
    /// GET request
    ///
    /// - parameter completion: callback result
    
    func get<T: RestObject>(_ completion: ObjectCompletion<T>? = nil) {
        dataRequest().responseJSON { response -> Void in
            self.handleResponse(response, completion, retry: { [weak self] in
                self?.get(completion)
            })
        }
    }
    
    func getArray<T: RestObject>(_ completion: ArrayCompletion<T>? = nil) {
        dataRequest().responseJSON { response -> Void in
            self.handleArrayResponse(response, completion, retry: { [weak self] in
                self?.getArray(completion)
            })
        }
    }
    
}

// MARK: - Request with object body

extension RestRequest {
    
    /// POST request
    ///
    /// - parameter objectBody: object param - type RESTParam
    /// - parameter completion: callback result
    func post<T: RestObject>(bodyParam param: RestParam? = nil, completion: ObjectCompletion<T>? = nil) {
        request(bodyParam: param, method: .post) { (object: T?, error) -> () in
            completion?(object, error)
        }
    }
    
    /// PUT request
    ///
    /// - parameter objectBody: object param - type RESTParam
    /// - parameter completion: callback result
    func put<T: RestObject>(bodyParam param: RestParam? = nil, completion: ObjectCompletion<T>? = nil) {
        request(bodyParam: param, method: .put) { (object: T?, error) -> () in
            completion?(object, error)
        }
    }
    
    /// PATCH request
    ///
    /// - parameter objectBody: object param - type RESTParam
    /// - parameter completion: callback result
    func patch<T: RestObject>(bodyParam param: RestParam? = nil, completion: ObjectCompletion<T>? = nil) {
        request(bodyParam: param, method: .patch)
        { (object: T?, error) -> () in
            completion?(object, error)
        }
    }
    
    /// DELETE request
    ///
    ///- parameter objectBody: object param - type RESTParam
    /// - parameter completion: callback result
    func delete<T: RestObject>(bodyParam param: RestParam? = nil, completion: ObjectCompletion<T>? = nil) {
        request(bodyParam: param, method: .delete) { (object: T?, error) -> () in
            completion?(object, error)
        }
    }
    
    /// Common request with object boby
    ///
    /// - parameter objectBody: object param - type RESTParam
    /// - parameter method:
    /// - parameter completion: call back
    func request<T: RestObject>(bodyParam objectBody: RestParam? = nil, method: Alamofire.HTTPMethod, completion: ObjectCompletion<T>? = nil) {
        let dictionary = objectBody?.toDictionary
        
        request(dictionary: dictionary, method: method) { (result: T?, error) -> () in
            completion?(result, error)
        }
    }
    
}

// MARK: - Request dictionary body

extension RestRequest {
    
    /// equest with dictionary parameters
    ///
    /// - parameter dictionaryParam: parameters
    /// - parameter method:          request method
    /// - parameter completion:      callback result
    
    func request<T: RestObject>(dictionary param: [String: Any]? = nil, method: Alamofire.HTTPMethod, completion: ObjectCompletion<T>? = nil) {
        if let param = param {
            parameters = param
        }
        
        dataRequest(method: method, encoding: JSONEncoding.default)
            .responseJSON { (response) -> Void in
                self.handleResponse(response, completion, retry: { [weak self] in
                    self?.request(dictionary: param, method: method, completion: completion)
                })
        }
    }
    
    func requestArray<T: RestObject>(dictionary param: [String: Any]? = nil, method: Alamofire.HTTPMethod, completion: ArrayCompletion<T>? = nil) {
        if let param = param {
            parameters = param
        }
        
        dataRequest(method: method, encoding: JSONEncoding.default)
            .responseJSON { (response) -> Void in
                self.handleArrayResponse(response, completion, retry: { [weak self] in
                    self?.requestArray(dictionary: param, method: method, completion: completion)
                })
        }
    }
    
}

// MARK: - Multiparts: Uploading files

extension RestRequest {
    
    /// POST request with multipart: file, data, string
    ///
    /// - parameter completion: callback result
    func postMultipart<T: RestObject>(_ completion: ObjectCompletion<T>? = nil) {
        upload(.post) { (object: T?, error) -> () in
            completion?(object, error)
        }
    }
    
    /// PUT request with multipart: file, data, string
    ///
    /// - parameter completion: callback result
    func putMultipart<T: RestObject>(_ completion: ObjectCompletion<T>? = nil) {
        upload(.put) { (object: T?, error) -> () in
            completion?(object, error)
        }
    }
    
    /// PATCH request with multipart: file, data, string
    ///
    /// - parameter completion: callback result
    func patchMultipart<T: RestObject>(_ completion: ObjectCompletion<T>? = nil) {
        upload(.patch) { (object: T?, error) -> () in
            completion?(object, error)
        }
    }
    
    /// Upload multipart: file, data, string
    ///
    /// - parameter method:     POST, PUT, PATCH
    /// - parameter completion: callback result
    fileprivate func upload<T: RestObject>(_ method: Alamofire.HTTPMethod, _ completion: ObjectCompletion<T>? = nil) {
        appendQueryParamsToURL()
        
        sessionManager.upload(
            multipartFormData: { (formData) -> Void in
                for part in self.multiparts {
                    formData.append(part.data,
                                    withName: part.name,
                                    fileName: part.fileName,
                                    mimeType: part.contentType)
                }
        },
            to: url,
            method: method,
            headers: headers,
            encodingCompletion: { (result) -> Void in
                switch result {
                case .success(let request, _, _):
                    request.validate(statusCode: 200..<400)
                        .responseJSON(completionHandler: { (response) -> Void in
                            self.handleResponse(response, completion, retry: { [weak self] in
                                self?.upload(method, completion)
                            })
                        })
                    
                case .failure(let error):
                    print(error)
                    
                    let restError = RestError(error: error)
                    completion?(nil, restError)
                }
        })
    }
    
}


// MARK: - Add Properties

extension RestRequest {
    
    func addObjectBodyParam(_ objectParam: RestParam) {
        parameters = objectParam.toDictionary
    }
    
    func addQueryParam(_ name: String, value: Any) {
        queryParameters[name] = "\(value)"
    }
    
    func addJsonPart(_ name: String, json: NSDictionary) {
        let part = RestMultipart.JSONPart(name: name, jsonObject: json)
        self.multiparts.append(part)
    }
    
    func addFilePart(_ name: String, fileName: String, data: Data!) {
        let part = RestMultipart.FilePart(name: name, fileName: fileName, data: data)
        self.multiparts.append(part)
    }
    
    func addStringPart(_ name: String, string: String) {
        let part = RestMultipart.StringPart(name: name, string: string)
        self.multiparts.append(part)    
    }
    
}

// MARK: - Set header, content type, accept, authorization

extension RestRequest {
    
    func addHeader(_ name: String, value: AnyObject) {
        headers[name] = value as? String
    }
    
    func setContentType(_ contentType: String) {
        headers[RestContant.requestContentTypeKey] = contentType
    }
    
    func setAccept(_ accept: String) {
        self.headers[RestContant.requestAcceptKey] = accept
    }
    
    func setAuthorization(_ authorization: String) {
        self.headers[RestContant.requestAuthorizationKey] = authorization
    }
    
}

extension RestRequest {
    
    fileprivate func appendQueryParamsToURL() {
        if queryParameters.isEmpty {
            return
        }
        
        var query: String = ""
        
        for (key, value) in queryParameters {
            if let paramValue = value as? String {
                if (query.lengthOfBytes(using: String.Encoding.utf8) == 0) {
                    query = "?"
                }
                else {
                    query += "&"
                }
                
                query = query + key + "=" + paramValue
            }
        }
        
        url = url + query
    }
    
}
