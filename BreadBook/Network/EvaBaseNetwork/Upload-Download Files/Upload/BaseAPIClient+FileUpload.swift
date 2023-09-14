//
//  BaseAPIClient+FileUpload.swift
//  
//
//  Created by Gamal Mostafa on 31/01/2022.
//

import Foundation

public extension BaseAPIClient {
    
    func uploadFile(
        apiConfig: APIConfigurationDelegate,
        timeoutInterval: Double = 30,
        progressHandler: ProgressHandler,
        completion: ((Result<Void, Error>) -> Void)?){
            guard let request = createURLRequest(withAPIConfig: apiConfig,timeoutInterval: timeoutInterval, completion: { error in completion?(.failure(error))})else {
                return
            }
            guard case let .uploadFile(url) = apiConfig.requestData
            else {
                if isDebugMode{
                    print("----ERROR----")
                    print("Upload File expects requestData to be of type .uploadFile(URL)")
                }
                
                completion?(.failure(APIError.generalError))
                return
            }
            let fileUploader = FileUploader(baseUrl: self.baseUrl, tokenHandler: self.tokenHandler, isDebugMode: isDebugMode)
            fileUploader.uploadFile(atUrl: url, withUrlRequest: request, progressHandler: progressHandler) { [weak self] data, response, error in
                if error != nil{
                    DispatchQueue.main.async {
                        completion?(.failure(APIError.generalError))
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    
                    if 200...204 ~= statusCode{
                        completion?(.success(()))
                    }
                    else if statusCode == 401{
                        self?.tokenHandler.refreshToken {
                            self?.uploadFile(apiConfig: apiConfig, progressHandler: progressHandler, completion: completion)
                        }
                    }
                    else {
                        completion?(.failure(NetworkError.init(withStatusCode: statusCode)))
                    }
                }
            }
            
            
        }
    
    
    
}
