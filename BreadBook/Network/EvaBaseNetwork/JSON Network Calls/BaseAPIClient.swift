//
//  BaseAPIClient.swift
//
//
//  Created by Gamal Mostafa on 11/01/2022.
//

import Foundation

open class BaseAPIClient : NSObject, URLSessionDelegate {
    var baseUrl : String
    var tokenHandler: TokenHandler
    internal var urlSession: URLSession?
    private(set) var isDebugMode: Bool
    
    public init(baseUrl: String,tokenHandler: TokenHandler, isDebugMode: Bool){
        self.baseUrl = baseUrl
        self.tokenHandler = tokenHandler
        self.isDebugMode = isDebugMode
        super.init()
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
    }
    
    @discardableResult
    public func performRequest<T:Decodable>(
        apiConfig: APIConfigurationDelegate,
        timeoutInterval: Double = 30,
        completion : ((Result<T,Error>) -> Void)?) -> URLSessionDataTask? {
            
            //1) Create URL Request
            guard let request = createURLRequest(withAPIConfig: apiConfig, timeoutInterval: timeoutInterval,  completion: { error in completion?(.failure(error))})
            else {
                return nil
            }
            
            //2) Create the data task and make the network call
            let task = createTaskAndHandleResponseHelper(withUrlRequest: request, apiConfig: apiConfig, completion: completion, unauthorizedHandler: {[weak self] in
                self?.performRequest(apiConfig: apiConfig, completion: completion)
            })
            task?.resume()
            return task;
            
        }
    
    //MARK: Create Url Request
    internal func createURLRequest(withAPIConfig apiConfig: APIConfigurationDelegate,timeoutInterval: Double, completion : ((Error) -> Void)?)-> URLRequest?{
        
        var body: [String:Any]?
        var queryItems: [String:String]?
        var bodyData: Data? = nil
        
        switch apiConfig.requestData {
        case .composite(let encodable, let dataQueryItems):
            body = encodable.asDictionary()
            queryItems = dataQueryItems
        case .encodable(let encodable):
            body = encodable.asDictionary()
            queryItems = nil
        case .queryItems(let dataQueryItems):
            queryItems = dataQueryItems
            body = nil
        case .dictionary(let dictionaryBody):
            body = dictionaryBody
            queryItems = nil
        case .plainRequest, .uploadFile:
            queryItems = nil
            body = nil
        case .multipartFormData(_): //Will be added in "BaseAPIClient+Multipart
            queryItems = nil
            body = nil
        case .rawData(let data):
            queryItems = nil
            body = nil
            bodyData = data
        case .queryItemsAsEncodable(let queryItemsAsEncodable):
            body = nil
            queryItems = queryItemsAsEncodable.asStringDictionary()
            
        }
        
        guard let url = createURL(path:apiConfig.path, queryItems:queryItems) else{
            if isDebugMode {
                print("[Error]: Failed to create URL")
            }
            completion?(APIError.generalError)
            return nil
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = timeoutInterval
        request.httpMethod = apiConfig.requestMethod.rawValue;
        
        if isDebugMode{
            print(request.httpMethod ?? "")
        }
        
        request = add(headers: apiConfig.headers, toURLRequest: request)
        request = add(body: body, bodyAsData: bodyData, toURLRequest: request, completion: completion)
        
        
        return request
    }
    
    //MARK: Create URL Request Helpers
    //1) Create URL
    internal func createURL(path: String, queryItems: [String:Any]?) -> URL?{
        var urlComponents = URLComponents(string: "\(baseUrl)\(path)")
        
        if let queryItems = queryItems {
            var urlQueryItems = [URLQueryItem]()
            for (key,value) in queryItems {
                urlQueryItems.append(URLQueryItem(name: key, value: String(describing: value)))
            }
            urlComponents?.queryItems = urlQueryItems
        }
        
        if isDebugMode{
            print("------------------------")
            print("[URL + Method]:")
            print(urlComponents?.url)
        }
        return urlComponents?.url
    }
    
    //2) Add Headers
    internal func add(headers: [String:String]?, toURLRequest request: URLRequest) -> URLRequest{
        var newRequest = request
        var headersToBeAdded : [String:String] = [:]
        if let serviceHeaders = headers {
            headersToBeAdded = headersToBeAdded.merging(serviceHeaders) { (_, new) in new }
        }
        if let token = tokenHandler.getAccessToken() {
            headersToBeAdded["Authorization"] = token
        }
        newRequest.allHTTPHeaderFields = headersToBeAdded
        if isDebugMode{
            print("[Headers]:")
            print(String(describing:headersToBeAdded))
        }
        return newRequest
    }
    
    //3) Add Body
    internal func add(body: [String:Any]?, bodyAsData: Data?, toURLRequest request: URLRequest, completion : ((Error) -> Void)?) -> URLRequest{
        guard ((body != nil) || (bodyAsData != nil)) else {
            return request
        }
        var newRequest = request
        do {
            var bodyData = bodyAsData
            if let body = body {
                let bodyToData = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                bodyData = bodyToData
            }
            
            if let bodyData = bodyData {
                newRequest.httpBody = bodyData
                if isDebugMode{
                    print("[Body] :")
                    print(String(data: bodyData, encoding: .utf8) ?? "")
                }
            }
            else if isDebugMode {
                print("[Body] :")
                print("Body is NIL")
            }
            
            
        }
        catch {
            completion?(error)
        }
        return newRequest
    }
    
    
    
    @available(macOS 12.0, iOS 13.0, *)
    open func performRequest<T:Decodable>(
        apiConfig: APIConfigurationDelegate, timeoutInterval: Double = 30) async -> Result<T,Error> {
            
            //1) Create URL Request
            guard let request = createURLRequest(withAPIConfig: apiConfig, timeoutInterval: timeoutInterval, completion: nil)
            else {
                return .failure(APIError.generalError)
            }
            
            return await createTaskAndHandleResponseHelper(withUrlRequest: request, apiConfig: apiConfig) {
                [weak self] in
                if let self = self {
                    return await self.performRequest(apiConfig: apiConfig)
                }
                else {
                    return .failure(APIError.generalError)
                }
            }
            
        }
    
    
    
}

public extension BaseAPIClient {
    //Create task and handle response helper:
    
    func createTaskAndHandleResponseHelper<T:Decodable>(withUrlRequest request: URLRequest,
                                                        apiConfig: APIConfigurationDelegate,
                                                        completion : ((Result<T,Error>) -> Void)?,
                                                        unauthorizedHandler: @escaping ()-> Void) -> URLSessionDataTask?{
        
        let task = urlSession?.dataTask(with: request) {[weak self] (data, response, error) in
            if let error = error{
                DispatchQueue.main.async {
                    if self?.isDebugMode ?? false {
                        print("[Error]: ")
                        print(error)
                    }
                    completion?(.failure(APIError.generalError))
                }
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                let isDebugMode = self?.isDebugMode ?? false
                
                //3) Handle status codes for different error types.
                if 200...204 ~= statusCode{
                    do {
                        if let data = data {
                            let result = try JSONDecoder().decode(EvaAPIResponse<T>.self, from: data)
                            
                            if isDebugMode{
                                print("[Response]: \(statusCode)")
                                print(String(data: data, encoding: .utf8) ?? "")
                            }
                            
                            if let resultData = result.data {
                                completion?(.success(resultData))
                            }
                            else{
                                completion?(.failure(APIError.serverError(result.message ?? "", result.errorList ?? [])))
                            }
                        }
                        else {
                            if isDebugMode {
                                print("[Error]: Data returned from API was nil")
                                
                            }
                            completion?(.failure(APIError.generalError))
                        }
                    }
                    catch{
                        if isDebugMode {
                            print("[Error]: ")
                            print(error)
                        }
                        completion?(.failure(APIError.generalError))
                    }
                }
                else if statusCode == 400 {
                    do {
                        if let data = data {
                            let result = try JSONDecoder().decode(EvaAPIResponse<T>.self, from: data)
                            
                            if isDebugMode{
                                print("[Response]: \(statusCode)")
                                print(String(data: data, encoding: .utf8) ?? "")
                            }
                            completion?(.failure(APIError.serverError(result.message ?? "", result.errorList ?? [])))
                        }
                    }
                    catch{
                        if isDebugMode {
                            print("[Error]: ")
                            print(error.localizedDescription)
                        }
                        completion?(.failure(APIError.generalError))
                    }
                }
                else if statusCode == 401{
                    if isDebugMode{
                        print("[Response]: \(statusCode)")
                        print("Refreshing Token.")
                    }
                    self?.tokenHandler.refreshToken {
                        unauthorizedHandler()
                    }
                }
                else {
                    completion?(.failure(NetworkError.init(withStatusCode: statusCode)))
                }
            }
        }
        return task
    }
}
