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
    
    // Feed
    @Root var start = makeFeed
    @ViewBuilder private func makeFeed() -> some View {
        FeedView(viewModel: .init(withRepository: FeedRepository()))
    }
    
    @Route(.push) var feed = makeFeedSearch
    @ViewBuilder private func makeFeedSearch(input: (
        searchKeyword: String?,
        selectedFilterId: Int,
        isClearSearch: ((Bool) -> Void)?,
        goBack: (() -> Void)?
    )) -> some View {
        FeedView(
            viewModel: .init(
                withRepository: FeedRepository(),
                searchKeyword: input.searchKeyword,
                selectedFilterId: input.selectedFilterId
            ),
            isClearSearch: input.isClearSearch,
            goBack: input.goBack
        )
    }
    func routeToFeedSearch(input: (
        searchKeyword: String?,
        selectedFilterId: Int,
        isClearSearch: ((Bool) -> Void)?,
        goBack: (() -> Void)?
    )) {
        self.route(to: \.feed, input)
    }
    
//    // Post
//    @Route(.push) var post = makePost
//    @ViewBuilder private func makePost(input: (
//        id: Int,
//        afterDeletionAction: (Int) -> Void,
//        afterEditAction: (FeedItem) -> Void,
//        onChange: (_ article: PostModel?, _ recentComments: [Comment]) -> Void
//    )) -> some View {
//        PostDetailsView(
//            postId: input.id,
//            reflectLike: input.onChange,
//            isFromFeed: true,
//            viewModel: .init(id: input.id, afterDeletionAction: input.afterDeletionAction, afterEditAction: input.afterEditAction, isFromProfile: false)
//        )
//    }
//    func routeToPost(input: (
//        id: Int,
//        afterDeletionAction: (Int) -> Void,
//        afterEditAction: (FeedItem) -> Void,
//        onChange: (_ article: PostModel?, _ recentComments: [Comment]) -> Void
//    )) {
//        self.route(to: \.post, input)
//    }
    
}
