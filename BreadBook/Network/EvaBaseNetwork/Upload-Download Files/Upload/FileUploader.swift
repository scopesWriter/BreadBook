//
//  FileUploader.swift
//  
//
//  Created by Gamal Mostafa on 31/01/2022.
//

import Foundation

class FileUploader: BaseAPIClient {
    
    public override init(baseUrl: String, tokenHandler: TokenHandler, isDebugMode: Bool){
        super.init(baseUrl: baseUrl, tokenHandler: tokenHandler, isDebugMode: isDebugMode)
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
    }
    
    private var progressHandlersByTaskID = [Int : ProgressHandler]()
    
    func uploadFile(
        atUrl fileURL: URL,
        withUrlRequest urlRequest: URLRequest,
        progressHandler: ProgressHandler,
        completion: @escaping ((Data?, URLResponse?, Error?) -> Void)
    ) {
        
        if let task = urlSession?.uploadTask(
            with: urlRequest,
            fromFile: fileURL,
            completionHandler:completion){
            progressHandlersByTaskID[task.taskIdentifier] = progressHandler
            task.resume()
        }
    }
    
    
}


extension FileUploader: URLSessionTaskDelegate {
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64
    ) {
        let progress = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
        if let handler = progressHandlersByTaskID[task.taskIdentifier]{
            handler!(progress)
        }
    }
    

}
