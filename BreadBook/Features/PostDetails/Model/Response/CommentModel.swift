//
//  CommentModel.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 15/09/2023.
//

import Foundation

// MARK: - Comment Element
struct CommentElement: Codable, Identifiable, Hashable {
    let id, postID: Int
    let name, email, body: String

    enum CodingKeys: String, CodingKey {
        case id
        case postID = "post_id"
        case name, email, body
    }
}

typealias Comments = [CommentElement]
