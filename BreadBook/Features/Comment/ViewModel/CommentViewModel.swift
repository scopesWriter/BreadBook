//
//  CommentViewModel.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation
import Combine

class CommentViewModel: ObservableObject {
   
    let id: Int
    let authorImage: String
    let hasReplies: Bool
    let comment: CommentBubbleViewModel
    
    init(
        id: Int,
        authorImage: String,
        hasReplies: Bool,
        comment: CommentBubbleViewModel
    ) {
        self.id = id
        self.authorImage = authorImage
        self.hasReplies = hasReplies
        self.comment = comment
    }
    
}

extension CommentViewModel {
    static var example: CommentViewModel {
        .init(id: 1, authorImage: "", hasReplies: false, comment: .example)
    }
}
