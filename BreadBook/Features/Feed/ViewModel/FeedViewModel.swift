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
    @Published var selectedItem: FeedItem?
    @Published var searchKeyword: String
    @Published var replyingOnComment: Comment?
    @Published var isPosting: Bool = false
    
    var reflectSearchActions = false
    @RouterObject var router: NavigationRouter<FeedCoordinator>?
    var splashRouter: SplashCoordinator.Router? = RouterStore.shared.retrieve()
    var mainRouter: MainTabCoordinator.Router? = RouterStore.shared.retrieve()
    var likedItemAt = -1
    var bookmarkedItemAt = -1
    var selectedFilterId = 0
    
    //var selectedFeedItemIdToManipulate = FeedItemManipulation(id: 0, canEdit: false)
    //var selectedFeedItemTypeId: ItemContentType?
    //var selectedPostItem: PostModel?
    
    // MARK: - Properties
    private let repo: FeedRepositoryProtocol
    //let postRepo: PostRepositoryProtocol
    var shouldLoadData: Bool
    var totalAPIs = 3
    var loadedAPIs = 0
    var errorAPIs = 0
    var subscriptions = Set<AnyCancellable>()
    //let addReaction = PassthroughSubject<(id: Int, itemType: ItemContentType, type: ReactionType), Never>()
    let didLoad = PassthroughSubject<Void, Never>()
    var shouldShowWriteCommentSection: Bool
    
    // MARK: - Pagination
    @Published var hasMoreData = true
    var currentPage = 1
    var totalPages = 1
    
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
        
        //let postRepository = PostRepository()
        //self.postRepo = postRepository
        self.shouldShowWriteCommentSection = true
        self.selectedFilterId = selectedFilterId
        super.init()
        self.isLoading = false
        setUpBinding()
    }
    
    private func setUpBinding() {
        //        addReaction
        //            .asyncMap { await self.commentsRepo.addReaction(payload: .init(
        //                itemId: $0.id,
        //                itemType: $0.itemType.rawValue,
        //                reactionType: $0.type
        //            )) }
        //            .sink { result in
        //                switch result {
        //                case .success(let reactions):
        //                    print("successfully adding reaction: \(reactions)")
        //                case .failure(let error):
        //                    print("error adding reaction: \(error.localizedDescription)")
        //                }
        //            }
        //            .store(in: &subscriptions)
        
        //        didLoad
        //            .first()
        //            .asyncMap { [weak self] _ in
        //                guard let self = self else { return }
        //                return await self.getNotifications()
        //            }
        //            .sink { _ in
        //                print("get notifications...")
        //            }
        //            .store(in: &subscriptions)
        
        setupDidLoadBinding()
    }
    
    func refresh() {
        currentPage = 1
        totalPages = 1
        didLoad.send()
    }
    
    func getFirstIndexToInsertNewPost() -> Int {
        for (index, item) in items.enumerated() {
            if case .filters = item {
                continue
            } else {
                return index
            }
        }
        return 0
    }
    
    //    func getIndexOfManipulatedPost(id: Int, type: ItemContentType) -> Int? {
    //        for (index, item) in items.enumerated() {
    //            if case .item(let feedItem) = item {
    //                if feedItem.id == id {
    //                    return index
    //                }
    //            }
    //        }
    //        return nil
    //    }
    
    // MARK: - Functions
    func checkIfEmptySearch() -> Bool {
        items.isEmpty &&
        !searchKeyword.isEmpty &&
        !isLoadingFeedItems
    }
    
    //    func like(item: FeedItem) async {
    //        DispatchQueue.main.async {
    //            //item.userReactionType = item.userReactionType == 1 ? 0 : 1
    //            if item.reactions?.count == 0 {
    //                item.reactions?.append(.init(reactionType: 1, count: 0))
    //            }
    //            item.reactions?[0].count? += item.userReactionType == 1 ? 1 : -1
    //            self.items = self.items
    //        }
    //        await putLike(item: item)
    //    }
    
    //    func createFiltersVMs(_ filters: [Filter]) -> [FeedFilterViewModel] {
    //        filters.enumerated().map { filterIndex, filter in
    //                .init(id: filter.id,
    //                      state: filterIndex == 0 ? .selected : .default,
    //                      isSelected: filterIndex == 0 ? true : false,
    //                      text: filter.name) { [weak self] in
    //                    guard let self = self else { return }
    //                    if self.selectedFilterId != filter.id {
    //                        self.isInitialLoad = true
    //                        self.selectedFilterId = filter.id
    //                        self.refresh()
    //                    }
    //                    self.setAnalyticsForNewsfeedFilters(
    //                        filterId: filter.id,
    //                        filterName: filter.name,
    //                        source: self.reflectSearchActions ? NewsfeedFilterDestination.search.rawValue : NewsfeedFilterDestination.newsfeed.rawValue
    //                    )
    //                }
    //        }
    //    }
    
    func createFeedItems(_ topics: [FeedTopic]) -> [FeedItem] {
        return []
        //        topics.map {
        //            .init(
        //                id: $0.id,
        //                userReactionType: $0.userReactionType,
        //                type: $0.type,
        //                authorId: $0.author.id,
        //                authorName: $0.author.fullName,
        //                authorImage: $0.author.profilePicture ?? "",
        //                mediaList: $0.mediaList,
        //                creationDate: $0.creationDate,
        //                text: $0.text,
        //                articleName: $0.articleName,
        //                reactions: $0.reactions,
        //                isBookmarked: $0.isBookmarked,
        //                deepLink: $0.deepLink,
        //                subSpecialties: $0.subSpecialties,
        //                podcastTitle: $0.podcastTitle,
        //                podcastNumberOfEpisodes: $0.podcastNumberOfEpisodes,
        //                commentsCount: $0.commentsCount,
        //                recentComment: $0.recentComment,
        //                activityLogType: $0.activityLogType,
        //                activityLogTime: $0.activityLogTime
        //            )
        //        }
    }
    
    func createDummyPost(withMedia: Bool) -> FeedItem {
        if withMedia {
            return FeedItem(id: 2, userReactionType: 0, type: .postWithMediaAndText, authorId: "12", authorName: "Gamaaaaaaaal", authorImage: "",
                            mediaList: [.init(mediaUrl: "", mediaTypeId: .image, thumbnailUrl: "")],
                            creationDate: "", text: "MY Text that is the post", articleName: "", isBookmarked: false, deepLink: "",subSpecialties: ["mySub"])
        } else {
            return FeedItem(id: 1, userReactionType: 0, type: .postWithTextOnly, authorId: "1", authorName: "Gamaaaaaaaal", authorImage: "", mediaList: [],
                            creationDate: "",
                            text: "MY Text that is the post so i want to put this as a placeholder text, may take a look",
                            articleName: "", isBookmarked: false, deepLink: "", subSpecialties: ["mySub"])
        }
        
    }
}

extension FeedViewModel {
    indirect enum FeedItemViewModel: Hashable, Identifiable {
        var id: Self { self }
        case item(_ item: FeedItem)
        case filters(_ filter: [FeedFilterViewModel])
    }
}

extension FeedViewModel {
    func setupDidLoadBinding() {
//        didLoad
//            .filter { [weak self]  in
//                guard let self = self else { return false }
//                return self.currentPage <= self.totalPages && !self.isLoadingFeedItems
//            }
//            .handleOutput { [weak self] _ in
//                guard let self = self else { return }
//                self.isLoadingFeedItems = true
//            }
//            .asyncMap { [weak self] _  -> Result<Page<NewsfeedItem>, Error> in
//                guard let self = self else { return .failure(AppError.empty) }
//                return await self.repo.getNewsfeed(
//                    filterId: self.selectedFilterId,
//                    searchKeyword: self.searchKeyword,
//                    pageNumber: self.currentPage
//                )
//            }
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] result in
//                guard let self = self else { return }
//                if self.currentPage == 1 {
//                    self.items.removeAll()
//                }
//
//                switch result {
//                case .success(let page):
//                    print("newsfeed page:")
//                    dump(page)
//                    for item in page.items {
//                        if let itemToAppend = self.getPageItemType(item: item) {
//                            self.items.append(itemToAppend)
//                        }
//                    }
//                    self.currentPage += 1
//                    self.totalPages = page.pagination.totalPages
//                    self.hasMoreData = self.currentPage <= self.totalPages
//                case .failure(let error):
//                    print("error getting newsfeed: \(error.localizedDescription)")
//                    if self.items.isEmpty { self.handleError() }
//                }
//                self.isLoadingFeedItems = false
//                self.isInitialLoad = false
//                self.pullToRefresh = false
//                self.objectWillChange.send()
//            }
//            .store(in: &subscriptions)
        
    }
    
//    func getPageItemType(item: NewsfeedItem) -> FeedItemViewModel? {
//        switch item {
//        case .post(let topic), .article(let topic):
//            if let item = self.createFeedItems([topic]).first {
//                return .item(item)
//            }
//        case .unknown:
//            break
//        }
//        return nil
//    }
}

enum AppError: Error {
    case empty
}
