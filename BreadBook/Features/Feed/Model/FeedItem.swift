//
//  FeedItem.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation
import Combine
// MARK: - FeedItem
class FeedItem: Codable, Hashable, ObservableObject {
 
    var id, userReactionType: Int
    var type: FeedItemType
    let authorId, authorName, authorImage: String
    let mediaList: [MediaListItem]
    var creationDate, text, articleName: String
    var reactions: [ReactionResponse]?
    var isBookmarked: Bool
    let deepLink: String
    let subSpecialties: [String]?
    let podcastTitle: String?
    let podcastNumberOfEpisodes: Int?
    var commentsCount: Int?
    var recentComment: [Comment]?
    var activityLogType: UserActivityType?
    var activityLogTime: String?
    
    init(id: Int, userReactionType: Int, type: FeedItemType, authorId: String, authorName: String, authorImage: String, mediaList: [MediaListItem], creationDate: String, text: String, articleName: String, reactions: [ReactionResponse]? = nil, isBookmarked: Bool, deepLink: String, subSpecialties: [String]? = nil, podcastTitle: String? = nil, podcastNumberOfEpisodes: Int? = nil, commentsCount: Int? = nil, recentComment: [Comment]? = nil, activityLogType: UserActivityType? = nil, activityLogTime: String? = nil) {
        self.id = id
        self.userReactionType = userReactionType
        self.type = type
        self.authorId = authorId
        self.authorName = authorName
        self.authorImage = authorImage
        self.mediaList = mediaList
        self.creationDate = creationDate
        self.text = text
        self.articleName = articleName
        self.reactions = reactions
        self.isBookmarked = isBookmarked
        self.deepLink = deepLink
        self.subSpecialties = subSpecialties
        self.podcastTitle = podcastTitle
        self.podcastNumberOfEpisodes = podcastNumberOfEpisodes
        self.commentsCount = commentsCount
        self.recentComment = recentComment
        self.activityLogType = activityLogType
        self.activityLogTime = activityLogTime
    }
    
    func findReactionTotalCount(type: Int) -> String {
        if ((self.reactions?.isEmpty) == nil) { return "" }
        let reaction = self.reactions?.first(where: { reaction in
            reaction.reactionType == type
        })
        return (reaction?.count ?? 0) > 0 ? "\(reaction?.count ?? 0)" : ""
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.isBookmarked == rhs.isBookmarked &&
        lhs.reactions == rhs.reactions &&
        lhs.userReactionType == rhs.userReactionType
    }
}

struct RecentlyJoinedDoctorModel: Codable {
    let recentlyJoined: [RecentlyJoinedItem]
}

// MARK: - RecentlyJoinedItem
struct RecentlyJoinedItem: Codable, Hashable {
    let id: String
    let name, specialty, countryId: String?
    let profilePicture: String?
    let subSpecialties: [String]?
    let isKol: Bool?
    let connectionStatus: FollowState
}

enum FollowState: Int, Codable {
    case follow = 1, followBack, following, follower
    
    var title: String {
        switch self {
        case .follow:
            return "Follow"
        case .followBack:
            return "Follow Back"
        case .following:
            return "Following"
        case .follower:
            return "Follower"
        }
    }
}


// MARK: - FeedItemElement
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

// MARK: - CommentElement
struct CommentElement: Codable, Identifiable {
    let id, postID: Int
    let name, email, body: String

    enum CodingKeys: String, CodingKey {
        case id
        case postID = "post_id"
        case name, email, body
    }
}

typealias Comments = [CommentElement]
