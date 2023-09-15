//
//  PostModel.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 15/09/2023.
//

import Foundation

// MARK: - Feed Item Element
struct FeedItemElement: Codable {
    let id, userID: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case title, body
    }
}

typealias FeedItems = [FeedItemElement]

