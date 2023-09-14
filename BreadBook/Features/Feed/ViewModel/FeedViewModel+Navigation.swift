//
//  FeedViewModel+Navigation.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Stinsen
import Foundation

extension FeedViewModel {
    
    func didTapOnSearch() {
        //        router?.coordinator.routeToSearch(input: (selectedFilterId: selectedFilterId, onChange: { [weak self] in
        //            guard let self = self else { return }
        //            self.reflectSearchActions = true
        //        }))
    }
    
    func didTapOnPost(item: FeedItem) {
        //        router?.coordinator.routeToPost(
        //            input: (
        //                id: item.id,
        //                afterDeletionAction: { [weak self] id in
        //
        //                    guard let self = self else {return}
        //                    self.selectedFeedItemIdToManipulate = .init(id: id, canEdit: true)
        //                    self.didDeleteItem.send(.newsFeed)
        //                },
        //                afterEditAction: { [weak self] newItem in
        //                    guard let self = self else {return}
        //                    DispatchQueue.main.async {
        //                        item.text = newItem.text
        //                        item.type = newItem.type
        //                        self.items = self.items
        //                    }
        //
        //                },
        //                onChange: { [weak self] post, recentComments in
        //                    guard let self = self else { return }
        //                    self.reflectLike(
        //                        item: item,
        //                        post: post,
        //                        recentComments: recentComments
        //                    )
        //                }
        //            )
        //        )
    }
    
    func showIncompleteProfileToast() {
        //        splashRouter?.coordinator.showToast(.init(
        //            type: .normal,
        //            title: "Make sure to complete your profile to experience all app features.",
        //            shouldHide: true,
        //            action: { [weak self] in
        //                guard let self = self else { return }
        //                self.splashRouter?.coordinator.hasRoot(\.mainTab)?.focusFirst(\.profile)
        //            }
        //        ))
    }
    
}
