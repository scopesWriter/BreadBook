//
//  APIConfigurationDelegate.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation

public protocol APIConfigurationDelegate {
    var path: String{ get }
    var requestMethod: RequestMethod{ get }
    var headers: [String: String]? { get }
    var requestData: RequestData { get }
}


public enum RequestMethod: String{
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

public enum RequestData {
    case plainRequest
    case encodable(Encodable)
    case queryItems([String:String])
    case composite(encodable: Encodable, queryItems: [String:String])
    case queryItemsAsEncodable(Encodable)
    case dictionary([String:Any])
    case uploadFile(URL)
    case multipartFormData([MultipartItem])
    case rawData(Data)
   
    
}

