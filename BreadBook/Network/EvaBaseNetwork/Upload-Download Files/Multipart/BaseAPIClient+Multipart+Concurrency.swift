//
//  BaseAPIClient+Multipart+Concurrency.swift
//  
//
//  Created by Gamal Mostafa on 04/04/2022.
//

import Foundation

@available(iOS 13.0.0, *)
public extension BaseAPIClient {
    func performMultipartRequest<T:Decodable>(
        apiConfig: APIConfigurationDelegate, timeoutInterval: Double = 30) async -> Result<T,Error> {
            guard var request = createURLRequest(withAPIConfig: apiConfig,timeoutInterval: timeoutInterval, completion: nil) else {
                return .failure(APIError.generalError)
            }
            
            guard case let .multipartFormData(multiPartFormData) = apiConfig.requestData else {
                if isDebugMode{
                    print("----ERROR----")
                    print("Multipart expects requestData to be of type .multipartFormData([MultipartItem])")
                }
                return .failure(APIError.generalError)
            }
            request = addMultipartHTTPBodyAndHeaders(toRequest: request, multiPartFormData: multiPartFormData)
            return await createTaskAndHandleResponseHelper(withUrlRequest: request, apiConfig: apiConfig){ [weak self] in
                if let self = self {
                    return await self.performMultipartRequest(apiConfig: apiConfig)
                }
                else {
                    return .failure(APIError.generalError)
                }
            }
        }
}
