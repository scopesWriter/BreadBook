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
    let subSpecialites: String
    let body: String
    let date: String
    let hasMenu: Bool
    @Published var isSending: Bool = false
    @Published var reactionsVMs: [ReactionCountViewModel]
    let onMenuTap: () -> Void
    let onAuthorTap: () -> Void
    
    init(
        author: String,
        subSpecialites: String,
        body: String,
        date: String,
        hasMenu: Bool,
        reactionsVMs: [ReactionCountViewModel],
        isSending: Bool,
        onMenuTap: @escaping () -> Void,
        onAuthorTap: @escaping() -> Void
    ) {
        self.author = author
        self.subSpecialites = subSpecialites
        self.body = body
        self.date = date
        self.hasMenu = hasMenu
        self.reactionsVMs = reactionsVMs
        self.isSending = isSending
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
                onTapAction: { _ in
                    //
                }
            )
            ,
            .init(
                id: 2,
                count: 50,
                isSelected: true,
                isIncremental: false,
                selectedImage: Icon.comment.rawValue,
                unselectedImage: Icon.comment.rawValue,
                onTapAction: { _ in
                    //
                }
            )
        ]
        
        return .init(
            author: "Dr. John Doe",
            subSpecialites: "Dermatology | Gynocology | Diabetes",
            body: """
            Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
            tempor Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor
            Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor
            """,
            date: "2 hrs ago",
            hasMenu: false,
            reactionsVMs: reactions,
            isSending: false,
            onMenuTap: {
                
            },
            onAuthorTap: {
                
            }
        )
    }
    
}

class ReactionCountViewModel: ObservableObject, Identifiable {
    
    let id: Int
    @Published var count: Int
    @Published var isSelected: Bool
    let isIncremental: Bool
    let isTapDisabled: Bool
    let selectedImage: String
    let unselectedImage: String
    private let onTapAction: (_ isSelected: Bool) -> Void
    
    init(
        id: Int,
        count: Int,
        isSelected: Bool,
        isIncremental: Bool = true,
        isTapDisabled: Bool = false,
        selectedImage: String,
        unselectedImage: String,
        onTapAction: @escaping (_ isSelected: Bool) -> Void
    ) {
        self.id = id
        self.count = count
        self.isSelected = isSelected
        self.isIncremental = isIncremental
        self.isTapDisabled = isTapDisabled
        self.selectedImage = selectedImage
        self.unselectedImage = unselectedImage
        self.onTapAction = onTapAction
    }
    
    func toggle() {
        if isIncremental {
            count += isSelected ? -1 : 1
        }
        isSelected.toggle()
        onTapAction(isSelected)
    }
    
}
