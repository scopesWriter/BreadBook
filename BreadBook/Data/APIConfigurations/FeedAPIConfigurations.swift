//
//  FeedAPIConfigurations.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation

enum FeedAPIConfiguration: APIConfigurationDelegate {
    case getNewsfeed
    case getComments
    
    var path: String {
        switch self {
        case .getNewsfeed:
            return "posts"
        case .getComments:
            return "comments"
        }
    }
    
    var requestMethod: RequestMethod {
        switch self {
        case .getNewsfeed, .getComments:
            return .get
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return baseHeaders
        }
    }
    
    var requestData: RequestData {
        switch self {
        case .getNewsfeed, .getComments:
            return .plainRequest
        }
    }
}
