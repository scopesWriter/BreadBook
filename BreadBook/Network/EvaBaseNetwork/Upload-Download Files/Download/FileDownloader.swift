//
//  FileDownloader.swift
//  
//
//  Created by Gamal Mostafa on 31/01/2022.
//

import Foundation

class FileDownloader: BaseAPIClient {
    typealias CompletionHandler = (URL?, URLResponse?, Error?) -> Void
    
    public override init(baseUrl: String,tokenHandler: TokenHandler,isDebugMode: Bool){
        super.init(baseUrl: baseUrl, tokenHandler: tokenHandler,isDebugMode: isDebugMode)
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
    }
    
    private var progressHandlersByTaskID = [Int : ProgressHandler]()
    private var completionHandlersByTaskID = [Int : CompletionHandler]()
    
    func downloadFile(
        withUrlRequest urlRequest: URLRequest,
        toLocation location: URL,
        progressHandler: ProgressHandler,
        completion: @escaping CompletionHandler)
    {
        if let task = urlSession?.downloadTask(with: urlRequest,completionHandler: completion){
            progressHandlersByTaskID[task.taskIdentifier] = progressHandler
            completionHandlersByTaskID[task.taskIdentifier] = completion
            task.resume()
        }
    }
}

extension FileDownloader: URLSessionDownloadDelegate, URLSessionTaskDelegate{
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        if let handler = completionHandlersByTaskID[downloadTask.taskIdentifier]{
            handler(location, downloadTask.response, nil)
        }
    }
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        if let handler = completionHandlersByTaskID[task.taskIdentifier]{
            handler(nil, task.response, error)
        }
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        if let handler = progressHandlersByTaskID[downloadTask.taskIdentifier]{
            handler!(progress)
        }
    }  
}
