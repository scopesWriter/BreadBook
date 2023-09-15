//
//  FeedRepoMockings.swift
//  BreadBookTests
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//


import XCTest

@testable import BreadBook

class FeedRepoMockSuccessfulFeed: FeedRepositoryProtocol {
    
    func fetchNewsFeed() async -> Result<BreadBook.FeedItems, Error> {
        var posts: [FeedItemElement] = []
        for i in 1...10 {
            let post: FeedItemElement = .init(id: i, userID: i*10, title: "Author\(i)", body: "")
            posts.append(post)
        }

        return .success(posts)
    }
    
    func fetchComments() async -> Result<BreadBook.Comments, Error> {
        var comments: [CommentElement] = []
        for i in 1...5 {
            let comment: CommentElement = .init(id: i, postID: i*100, name: "Author\(i)", email: "", body: "")
            comments.append(comment)
        }
        return .success(comments)
    }
    
}

class FeedRepoMockFail: FeedRepositoryProtocol {
    
    func fetchNewsFeed() async -> Result<BreadBook.FeedItems, Error> {
        return .failure(APIError.serverError("", []))
    }
    
    func fetchComments() async -> Result<BreadBook.Comments, Error> {
        return .failure(APIError.serverError("", []))
    }
    
}

