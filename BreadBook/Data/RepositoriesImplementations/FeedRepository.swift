//
//  FeedRepository.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation

class FeedRepository: FeedRepositoryProtocol {
    
    // MARK: - APIClient
    private let apiClient: BreadBookAPIClient
    
    // MARK: - Init
    init() {
        self.apiClient = BreadBookAPIClient()
    }
    
    func fetchNewsFeed() async -> Result<FeedItems, Error> {
        let result = await apiClient.fetchNewsFeed()
        switch result {
        case .success(let response):
            BreadBookStorage.newsfeedItems = response
            return .success(response)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func fetchComments() async -> Result<Comments, Error> {
        let result = await apiClient.fetchComments()
        switch result {
        case .success(let response):
            return .success(response)
        case .failure(let error):
            return .failure(error)
        }
    }
    
}
