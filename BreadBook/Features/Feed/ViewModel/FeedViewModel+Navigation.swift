//
//  FeedViewModel+Navigation.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Stinsen

extension FeedViewModel {
    
    func didTapOnPost(item: FeedItem) {
        router?.coordinator.routeToPost(
            post: .init(
                id: item.id,
                userID: Int(item.authorId) ?? 0,
                title: item.authorName,
                body: item.text
            )
        )
    }
    
}
