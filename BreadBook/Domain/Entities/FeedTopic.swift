//
//  FeedTopic.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation

enum UserActivityType: Int, Codable {
    case empty = 0
    case creation = 1
    case comment = 2
    case reaction = 3
}

enum FeedItemType: Int, Codable {
    case postWithTextOnly = 2
}

struct Comment: Codable {
    var id: Int
    let creationDate: String
    var body: String
    var reactions: [Reaction]
    var userReactionType: ReactionType
    var repliesCount: Int
    var replies: [Comment]
}

extension Comment: Hashable {
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Author: Codable {
    let id: String
    let fullName: String
    let profilePicture: String?
    let subSpecialties: [String]
}

struct ReactionResponse: Codable, Hashable {
    
    var reactionType: Int? = 0
    var count: Int? = 0
    
    func toReaction() -> Reaction {
        return Reaction(type: .init(rawValue: self.reactionType ?? 0) ?? .like, count: self.count ?? 0)
    }
    
    static func convertArray(_ input: [ReactionResponse]) -> [Reaction] {
        var output: [Reaction] = []
        for item in input {
            output.append(item.toReaction())
        }
        return output
    }
}

struct Reaction: Codable {
    let type: ReactionType
    var count: Int
}

extension Reaction {
    enum CodingKeys: String, CodingKey {
        case type = "reactionType"
        case count
    }
}

enum ReactionType: Int {
    case none = 0
    case like = 1
}

extension ReactionType: Codable {
    
    init(from decoder: Decoder) throws {
        let type = try decoder.singleValueContainer().decode(Int.self)
        switch type {
        case 1:
            self = .like
        default:
            self = .none
        }
    }
    
}

