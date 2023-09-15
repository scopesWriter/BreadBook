//
//  FeedViewModel.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI
import Combine
import Stinsen

class FeedViewModel: BaseViewModel, ObservableObject {
    
    // MARK: - Data Sources
    @Published var items: [FeedItemViewModel] = []
    @Published var isLoadingFeedItems = false
    @Published var isInitialLoad = true
    @Published var pullToRefresh: Bool?
    @Published var searchKeyword: String
    
    // MARK: - Router
    @RouterObject var router: NavigationRouter<FeedCoordinator>?
    
    // MARK: - Properties
    let repo: FeedRepositoryProtocol
    var shouldLoadData: Bool
    var shouldShowWriteCommentSection: Bool
    
    // MARK: - Inputs
    let didLoad = PassthroughSubject<Void, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        withRepository repo: FeedRepositoryProtocol,
        searchKeyword: String? = nil,
        selectedFilterId: Int = 0,
        isInitialAppLoad: Bool = true
    ) {
        self.repo = repo
        self.shouldLoadData = true
        self.isInitialLoad = true
        self.searchKeyword = searchKeyword ?? ""
        
        self.shouldShowWriteCommentSection = true
        super.init()
        self.isLoading = false
        setupDidLoadBinding()
    }
    
    // MARK: - DeInit
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    // MARK: - Functions
    func refresh() {
        didLoad.send()
    }
    
    func checkIfEmptySearch() -> Bool {
        items.isEmpty &&
        !searchKeyword.isEmpty &&
        !isLoadingFeedItems
    }
    
    func createFeedItems(_ topics: FeedItems) -> [FeedItem] {
        topics.map {
            .init(
                id: $0.id,
                userReactionType: 0,
                type: .postWithTextOnly,
                authorId: "\($0.userID)",
                authorName: $0.title,
                authorImage: "",
                creationDate: "",
                text: $0.body,
                articleName: "",
                reactions: [],
                isBookmarked: false,
                deepLink: "",
                subSpecialties: [],
                podcastTitle: "",
                podcastNumberOfEpisodes: 0,
                commentsCount: 0,
                recentComment: [],
                activityLogType: .empty,
                activityLogTime: ""
            )
        }
    }
    
    func createDummyPost(withMedia: Bool) -> FeedItem {
        return FeedItem(
            id: 1,
            userReactionType: 0,
            type: .postWithTextOnly,
            authorId: "1",
            authorName: "Bishoy Badie",
            authorImage: "",
            creationDate: "",
            text: "MY Text that is the post so i want to put this as a placeholder text, may take a look",
            articleName: "",
            isBookmarked: false,
            deepLink: "",
            subSpecialties: ["mySub"]
        )
    }
}

extension FeedViewModel {
    indirect enum FeedItemViewModel: Hashable, Identifiable {
        var id: Self { self }
        case item(_ item: FeedItem)
    }
}

// MARK: Binding
extension FeedViewModel {
    func setupDidLoadBinding() {
        didLoad
            .handleOutput { [weak self] _ in
                guard let self = self else { return }
                self.isLoadingFeedItems = true
            }
            .asyncMap { [weak self] _ -> Result<FeedItems, Error> in
                guard let self = self else { return .failure(AppError.empty) }
                return await self.repo.fetchNewsFeed()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let items):
                    dump(items)
                    for item in items {
                        if let itemToAppend = self.getPageItemType(item: item) {
                            self.items.append(itemToAppend)
                        }
                    }
                case .failure(let error):
                    print("error getting newsfeed: \(error.localizedDescription)")
                    if self.items.isEmpty { self.handleError() }
                }
                self.isLoadingFeedItems = false
                self.isInitialLoad = false
                self.pullToRefresh = false
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Mapper
    func getPageItemType(item: FeedItemElement) -> FeedItemViewModel? {
        if let item = self.createFeedItems([item]).first {
            return .item(item)
        }
        return nil
    }
}

enum AppError: Error {
    case empty
}
