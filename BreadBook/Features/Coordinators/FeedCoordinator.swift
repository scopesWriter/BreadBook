//
//  FeedCoordinator.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI
import Stinsen

final class FeedCoordinator: NavigationCoordinatable {
    
    let stack = NavigationStack(initial: \FeedCoordinator.start)
    lazy var routerStorable: FeedCoordinator = self
    
    // MARK: - Feed
    @Root var start = makeFeed
    @ViewBuilder private func makeFeed() -> some View {
        FeedView(viewModel: .init(withRepository: FeedRepository()))
    }
    
    // MARK: - Post Details
    @Route(.push) var post = makePost
    @ViewBuilder private func makePost(post: FeedItemElement) -> some View {
        PostDetailsView(
            viewModel: .init(post: post)
        )
    }
    func routeToPost(post: FeedItemElement) {
        self.route(to: \.post, post)
    }
    
}
