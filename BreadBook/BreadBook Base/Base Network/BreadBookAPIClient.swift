//
//  BreadBookAPIClient.swift
//  BreadBook
//
//  Created by Gamal Mostafa on 24/01/2022.
//  Copyright © 2022 Limitless Care. All rights reserved.
//

import Foundation

class BreadBookAPIClient: BaseAPIClient {
    
    convenience init() {
        self.init(baseUrl: Constants.baseURL)
    }
    
    func fetchNewsFeed() async -> Result<FeedItems, Error> {
        await self.performRequest(apiConfig: FeedAPIConfiguration.getNewsfeed)
    }
    
    func fetchComments() async -> Result<Comments, Error> {
        await self.performRequest(apiConfig: FeedAPIConfiguration.getComments)
    }
    
    // MARK: Override perform request to check for token expiry date before request.
    override func performRequest<T>(apiConfig: APIConfigurationDelegate, timeoutInterval: Double = 30) async -> Result<T, Error> where T : Decodable {
        return await super.performRequest(apiConfig: apiConfig, timeoutInterval: timeoutInterval)
    }
    
}
