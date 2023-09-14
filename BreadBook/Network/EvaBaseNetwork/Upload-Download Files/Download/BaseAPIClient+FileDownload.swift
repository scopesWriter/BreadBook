//
//  BaseAPIClient+FileDownload
//  
//
//  Created by Gamal Mostafa on 31/01/2022.
//

import Foundation


extension BaseAPIClient {
    
    func downloadFile(
        toDestination destination: URL,
        apiConfig: APIConfigurationDelegate,
        timeoutInterval: Double = 30,
        progressHandler: ProgressHandler,
        completion: ((Result<Void, Error>) -> Void)?){
            guard let request = createURLRequest(withAPIConfig: apiConfig, timeoutInterval: timeoutInterval, completion: { error in completion?(.failure(error))})else {
                return
            }
            let fileDownloader = FileDownloader(baseUrl: self.baseUrl, tokenHandler: self.tokenHandler, isDebugMode: isDebugMode)
            fileDownloader.downloadFile(withUrlRequest: request, toLocation: destination, progressHandler: progressHandler) {[weak self] location, response, error in
                if error != nil{
                    DispatchQueue.main.async {
                        completion?(.failure(APIError.generalError))
                    }
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    
                    let isDebugMode = self?.isDebugMode ?? false
                    
                    if 200...204 ~= statusCode{
                        guard let location = location else {
                            if isDebugMode{
                                print("----ERROR----")
                                print("No Location found.")
                            }
                            completion?(.failure(APIError.generalError))
                            return
                        }
                        do {
                            try FileManager.default.moveItem(at: location, to: destination)
                            completion?(.success(()))
                        }
                        catch{
                            if isDebugMode{
                                print("----ERROR----")
                                print("Unable to write file to destination.")
                            }
                            completion?(.failure(APIError.generalError))
                        }
                        
                    }
                    else if statusCode == 401{
                        self?.tokenHandler.refreshToken {
                            self?.downloadFile(toDestination: destination, apiConfig: apiConfig, progressHandler: progressHandler, completion: completion)
                        }
                    }
                    else {
                        completion?(.failure(NetworkError.init(withStatusCode: statusCode)))
                    }
                }
                
                
            }
            
        }
}
