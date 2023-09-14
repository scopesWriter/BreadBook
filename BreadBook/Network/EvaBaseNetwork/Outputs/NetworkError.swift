//
//  NetworkError.swift
//
//
//  Created by Gamal Mostafa on 11/01/2022.
//

import Foundation


import Foundation

extension Error
{
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}

public enum NetworkError: Int,Error
{
    // MARK: Informational
    case `continue` = 100
    case switchingProtocols = 101
    case processing = 102
    
    // MARK: Success
    case ok = 200
    case created = 201
    case accepted = 202
    case nonAuthoritativeInformation = 203
    case noContent = 204
    case resetContent = 205
    case partialContent = 206
    case multiStatus = 207
    case alreadyReported = 208
    case imUsed = 226
    
    // MARK: Redirection
    case multipleChoices = 300
    case movedPermanently = 301
    case found = 302
    case seeOther = 303
    case notModified = 304
    case useProxy = 305
    case temporaryRedirect = 307
    case permanentRedirect = 308
    
    // MARK: Client Error
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case lengthRequired = 411
    case preconditionFailed = 412
    case payloadTooLarge = 413
    case requestURITooLong = 414
    case unsupportedMediaType = 415
    case requestedRangeNotSatisfiable = 416
    case expectationFailed = 417
    case iAmATeapot = 418
    case misdirectedRequest = 421
    case unprocessableEntity = 422
    case locked = 423
    case failedDependency = 424
    case upgradeRequired = 426
    case preconditionRequired = 428
    case tooManyRequests = 429
    case requestrHeaderrFieldsrToorLarge = 431
    case connectionClosedWithoutResponse = 444
    case unavailableForLegalReasons = 451
    case clientClosedRequest = 499
    
    // MARK: Server Error
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case httpVersionNotSupported = 505
    case variantAlsoNegotiates = 506
    case insufficientStorage = 507
    case loopDetected = 508
    case notExtended = 510
    case networkAuthenticationRequired = 511
    case networkConnectTimeoutError = 599
    
    case noConnection
    case noData
    case unknownError
    case parsingJSONError
        
    init(withError error: Error)
    {
        let error: NSError = error as NSError
        if error.domain == NSURLErrorDomain
        {
            switch error.code
            {
            case NSURLErrorResourceUnavailable:
                self = .noData
            case NSURLErrorNotConnectedToInternet:
                self = .noConnection
            case NSURLErrorCannotDecodeRawData, NSURLErrorCannotDecodeContentData, NSURLErrorCannotParseResponse:
                self = .parsingJSONError
            default:
                self = Self.init(withStatusCode: error.code)
            }
            return
        }
        
        self = .unknownError
    }
    
    init(withStatusCode statusCode: Int)
    {
        self = NetworkError(rawValue: statusCode) ?? .unknownError
    }
}

extension NetworkError: LocalizedError
{
    public var errorDescription: String?
    {
        if self == .unknownError  {
            return "error.GeneralError".moduleLocalized()
            
        }
        else {
            return "statusCode_\(rawValue)".moduleLocalized()
        }
    }
}

public enum APIError
{
    case internetError(String)
    case serverMessage(String)
    case serverError(String,[EvaErrorListItem])
    case generalError
    case decodingError(statusCode: Int)
}


extension APIError: LocalizedError
{
    public var errorDescription: String?
    {
        switch self
        {
        case .internetError(let message):
            return message
        case .serverMessage(let message):
            return message
        case .serverError(let message, let errorList):
            if message.count > 0 {
                return message
            } else if errorList.count > 0 {
                return errorList.map{$0.message ?? ""}.joined(separator: "|")
            } else {
                return ""
            }
        case .generalError:
            return NSLocalizedString("Something went wrong, please try again later", comment: "")
        case .decodingError(let statusCode):
            return "Decoding Error, Status Code: \(statusCode)"
        }
    }
}


public enum EvaError
{
    case generateError(withMessage: String)
}


extension EvaError: LocalizedError
{
    public var errorDescription: String?
    {
        switch self
        {
        case .generateError(let message):
            return message
        }
    }
}
