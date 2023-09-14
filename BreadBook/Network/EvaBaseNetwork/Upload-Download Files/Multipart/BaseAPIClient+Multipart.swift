//
//  BaseAPIClient+Multipart.swift
//  
//
//  Created by Gamal Mostafa on 31/01/2022.
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
                if isDebugMode{
                    print("----ERROR----")
                    print("Multipart expects requestData to be of type .multipartFormData([MultipartItem])")
                }
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
        
        if isDebugMode{
            print(httpBodyString)
        }
        
        return request
    }
}
