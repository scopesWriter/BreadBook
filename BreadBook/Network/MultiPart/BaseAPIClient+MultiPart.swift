//
//  BaseAPIClient+MultiPart.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation

public extension BaseAPIClient{
    @discardableResult
    func performMultipartRequest<T:Decodable>(
        apiConfig: APIConfigurationDelegate,
        timeoutInterval: Double = 30,
        completion : ((Result<T,Error>) -> Void)?) -> URLSessionDataTask? {
            guard var request = createURLRequest(withAPIConfig: apiConfig, timeoutInterval: timeoutInterval, completion: { error in completion?(.failure(error))})
            else {
                return nil
            }
            
            guard case let .multipartFormData(multiPartFormData) = apiConfig.requestData else {
                completion?(.failure(APIError.generalError))
                return nil
            }
            request = addMultipartHTTPBodyAndHeaders(toRequest: request, multiPartFormData: multiPartFormData)
            let task = createTaskAndHandleResponseHelper(withUrlRequest: request, apiConfig: apiConfig, completion: completion, unauthorizedHandler: { [weak self] in
                self?.performMultipartRequest(apiConfig: apiConfig, completion: completion)
                
            })
            task?.resume()
            return task
        }
    
    
    func addMultipartHTTPBodyAndHeaders(toRequest :URLRequest, multiPartFormData: [MultipartItem]) -> URLRequest {
        
        var request = toRequest
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let httpBody = NSMutableData()
        var httpBodyString = ""
        
        for multipartItem in multiPartFormData {
            if multipartItem is MultipartFormItem {
                let multiPartFormItem = multipartItem as! MultipartFormItem
                let formItem = convertFormField(named: multiPartFormItem.name, value: multiPartFormItem.value, using: boundary)
                httpBody.appendString(formItem)
                httpBodyString += formItem + "\n"
            }
            else if multipartItem is MultipartDataItem{
                let multiPartDataItem = multipartItem as! MultipartDataItem
                httpBody.append(convertFileData(fieldName: multiPartDataItem.fieldName, fileName: multiPartDataItem.fileName, mimeType: multiPartDataItem.mimeType, fileData: multiPartDataItem.fileData, using: boundary))
            }
        }
        
        httpBody.appendString("--\(boundary)--")
        request.httpBody = httpBody as Data
        
        
        
        return request
    }
}
