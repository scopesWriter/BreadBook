//
//  PostViewModel.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation
import Combine
import Stinsen

// swiftlint:disable type_body_length
class PostViewModel: BaseViewModel, ObservableObject {
    
    // MARK: - Variables
    @Published var post: FeedItemElement
    @Published var selectedCommentOrReplyAuthorId = ""
    var shouldUpdateComments: Bool = false
    @Published var isLoadingComments: Bool = false
    
    // MARK: - Router
    @RouterObject var router: NavigationRouter<FeedCoordinator>?
    var splashRouter: SplashCoordinator.Router? = RouterStore.shared.retrieve()
    
    private let repo: FeedRepositoryProtocol
    private let getComments = PassthroughSubject<Void, Never>()
    let willDismissKeyboard = PassthroughSubject<Void, Never>()
    
    // MARK: - Placeholders
    private let commentPlaceholder = "Write a comment.."
    private let replyPlaceholder = "Replying to "
    @Published var newCommentPlaceholder: String = "Write a comment.."
    @Published var isCommentFocused: Bool = false
    @Published var comments: [CommentItem] = []
    
    // MARK: - Inputs
    let didLoad = PassthroughSubject<Void, Never>()
    let didScrollToBottom = PassthroughSubject<Void, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    init(post: FeedItemElement) {
        self.post = post
        self.repo = FeedRepository()
        super.init()
        self.isLoading = false
        setUpBinding()
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    private func setUpBinding() {
        
        getComments
            .asyncMap { await self.repo.fetchComments() }
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                if self.isLoadingComments { self.isLoadingComments = false }
                switch result {
                case .success(let fetchedComments):
                    self.comments = self.createCommentsItems(fetchedComments)
                case .failure(let error):
                    print("error getting comments: \(error.localizedDescription)")
                }
            }
            .store(in: &subscriptions)
        
        didLoad
            .sink { [weak self] in
                guard let self = self else { return }
                self.isLoadingComments = true
                self.getComments.send()
            }
            .store(in: &subscriptions)
        
        willDismissKeyboard
            .sink {
                self.newCommentPlaceholder = self.commentPlaceholder
            }
            .store(in: &subscriptions)
        
    }
    
    func createCommentsItems(_ comments: Comments) -> [CommentItem] {
        var items: [CommentItem] = []
        for comment in comments {
            
            let reactionsVMs: [ReactionCountViewModel] = [
                .init(
                    id: comment.id,
                    count: 0,
                    isSelected: false,
                    selectedImage: Icon.likeFilled.rawValue,
                    unselectedImage: Icon.likeUnfilled.rawValue,
                    onTapAction: { _ in
                        self.shouldUpdateComments = true
                    }
                ),
                .init(
                    id: 99,
                    count: comments.count,
                    isSelected: false,
                    isIncremental: false,
                    selectedImage: Icon.comment.rawValue,
                    unselectedImage: Icon.comment.rawValue,
                    onTapAction: { [weak self] _ in
                        guard let self = self else { return }
                        self.isCommentFocused = true
                    }
                )
            ]
            
            let commentVM: CommentViewModel = .init(
                id: comment.id,
                authorImage: Icon.profilePlaceholderImage.rawValue,
                hasReplies: false,
                comment: .init(
                    author: comment.name,
                    subSpecialites: "",
                    body: comment.body,
                    date: "",
                    hasMenu: true,
                    reactionsVMs: reactionsVMs,
                    isSending: false,
                    onMenuTap: {},
                    onAuthorTap: {}
                )
            )
            
            items.append(.init(vm: commentVM, replies: []))
        }
        return items
    }
    
}
