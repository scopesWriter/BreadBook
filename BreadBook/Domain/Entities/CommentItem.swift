//
//  CommentItem.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation

struct CommentItem {
    var vm: CommentViewModel
    var replies: [ReplyViewModel]
}

extension CommentItem: Identifiable {
    var id: String {
        return "c\(vm.id)"
    }
}

extension CommentItem: Equatable {
    static func == (lhs: CommentItem, rhs: CommentItem) -> Bool {
        lhs.id == rhs.id
    }
}

extension CommentItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class ReplyViewModel: ObservableObject {
    
    let id: Int
    let authorImage: String
    let hasNext: Bool
    let reply: CommentBubbleViewModel
    
    init(
        id: Int,
        authorImage: String,
        hasNext: Bool,
        reply: CommentBubbleViewModel
    ) {
        self.id = id
        self.authorImage = authorImage
        self.hasNext = hasNext
        self.reply = reply
    }
    
}

class CommentBubbleViewModel: ObservableObject {
    let author: String
    let body: String
    let hasMenu: Bool
    @Published var reactionsVMs: [ReactionCountViewModel]
    let onMenuTap: () -> Void
    let onAuthorTap: () -> Void
    
    init(
        author: String,
        body: String,
        hasMenu: Bool,
        reactionsVMs: [ReactionCountViewModel],
        onMenuTap: @escaping () -> Void,
        onAuthorTap: @escaping() -> Void
    ) {
        self.author = author
        self.body = body
        self.hasMenu = hasMenu
        self.reactionsVMs = reactionsVMs
        self.onMenuTap = onMenuTap
        self.onAuthorTap = onAuthorTap
    }
    
}

extension CommentBubbleViewModel {
    
    static var example: CommentBubbleViewModel {
        
        let reactions: [ReactionCountViewModel] = [
            .init(
                id: 1,
                count: 10,
                isSelected: false,
                selectedImage: Icon.likeFilled.rawValue,
                unselectedImage: Icon.likeUnfilled.rawValue,
                onTapAction: { _ in }
            )
            ,
            .init(
                id: 2,
                count: 50,
                isSelected: true,
                isIncremental: false,
                selectedImage: Icon.comment.rawValue,
                unselectedImage: Icon.comment.rawValue,
                onTapAction: { _ in }
            )
        ]
        
        return .init(
            author: "Bishoy Badie",
            body: """
            Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
            tempor Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor
            Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor
            """,
            hasMenu: false,
            reactionsVMs: reactions,
            onMenuTap: {},
            onAuthorTap: {}
        )
    }
    
}
