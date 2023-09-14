//
//  BaseAPIClient+Concurrency.swift.swift
//  
//
//  Created by Gamal Mostafa on 18/01/2022.
//

import Foundation

@available(macOS 10.15,iOS 13.0, *)
public extension BaseAPIClient {
    func createTaskAndHandleResponseHelper<T:Decodable>(withUrlRequest request: URLRequest,
                                                        apiConfig: APIConfigurationDelegate,
                                                        unauthorizedHandler: @escaping () async -> Result<T,Error>) async -> Result<T,Error> {
        
        do {
            let taskResponse = try await urlSession?.data(for: request)
            guard let httpResponse = taskResponse?.1 as? HTTPURLResponse else{
                return .failure(APIError.generalError)
            }
            let statusCode = httpResponse.statusCode
            
            if 200...204 ~= statusCode{
                do {
                    guard let data = taskResponse?.0 else {
                        return .failure(APIError.generalError)
                    }
                    let result = try JSONDecoder().decode(EvaAPIResponse<T>.self, from: data)
                    
                    if isDebugMode{
                        print("[Response]: \(statusCode)")
                        print(String(data: data, encoding: .utf8) ?? "")
                    }
                    
                    if let resultData = result.data {
                        return .success(resultData)
                    }
                    else{
                        return .failure(APIError.serverError(result.message ?? "", result.errorList ?? []))
                    }
                }
                catch{
                    if isDebugMode {
                        print("[Error]: ")
                        print(error)
                    }
                    return .failure(APIError.decodingError(statusCode: statusCode))
                }
            }
            else if statusCode == 400 {
                do {
                    guard let data = taskResponse?.0 else {
                        return .failure(APIError.generalError)
                    }
                    let result = try JSONDecoder().decode(EvaAPIResponse<T>.self, from: data)
                    return .failure(APIError.serverError(result.message ?? "", result.errorList ?? []))
                }
                catch{
                    if isDebugMode {
                        print("[Error]: ")
                        print(error)
                    }
                    return .failure(APIError.decodingError(statusCode: statusCode))
                }
            }
            else if statusCode == 401{
                let success = await tokenHandler.refreshToken()
                if success {
                    let result : Result<T,Error> = await unauthorizedHandler()
                    return result
                }
                else {
                    return .failure(APIError.generalError)
                }
            }
            else {
                return .failure(NetworkError.init(withStatusCode: statusCode))
            }
        }
        catch{
            if isDebugMode {
                print("[Error]: ")
                print(error)
            }
            return .failure(APIError.generalError)
        }
    }
}

@available(macOS 10.15,iOS 13.0, *)
@available(iOS, deprecated: 15.0, message: "Use the built-in API instead")
extension URLSession {
    func data(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }
                
                continuation.resume(returning: (data, response))
            }
            
            task.resume()
        }
    }
}
