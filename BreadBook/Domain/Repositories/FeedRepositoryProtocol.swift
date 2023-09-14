//
//  FeedRepositoryProtocol.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation

protocol FeedRepositoryProtocol {
    func fetchNewsFeed() async -> Result<FeedItems, Error>
    func fetchComments() async -> Result<Comments, Error>
}
