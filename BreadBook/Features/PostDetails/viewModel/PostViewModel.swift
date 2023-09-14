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
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Variables
    private let id: Int
    private let repo: FeedRepositoryProtocol
    @Published var post: FeedItemElement?
    @RouterObject var router: NavigationRouter<FeedCoordinator>?
    var splashRouter: SplashCoordinator.Router? = RouterStore.shared.retrieve()
    var enableBookmarkReactionAPICall: Bool = true
    var shouldUpdateComments: Bool = false
    
    @Published var selectedCommentOrReplyAuthorId = ""
    private let getComments = PassthroughSubject<Void, Never>()
    private let addComment = PassthroughSubject<String, Never>()
    @Published var newCommentText: String = ""
    let didLoad = PassthroughSubject<Void, Never>()
    let didScrollToBottom = PassthroughSubject<Void, Never>()
    let didTapOnSend = PassthroughSubject<Void, Never>()
    @Published var isLoadingComments: Bool = false
    private var comments: Comments = []
    
    let willDismissKeyboard = PassthroughSubject<Void, Never>()
    
    private let commentPlaceholder = "Write a comment.."
    private let replyPlaceholder = "Replying to "
    @Published var newCommentPlaceholder: String = "Write a comment.."
    @Published var isCommentFocused: Bool = false
    
    // MARK: - Init
    init(id: Int) {
        self.id = id
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
        
        //        getComments
        //            .asyncMap { await self.commentsRepo.getComments(payload: self.payload) }
        //            .receive(on: RunLoop.main)
        //            .sink { [weak self] result in
        //                guard let self = self else { return }
        //                if self.isLoadingComments { self.isLoadingComments = false }
        //                if self.isLoadingCommentsNextPage { self.isLoadingCommentsNextPage = false }
        //                switch result {
        //                case .success(let page):
        //                    self.totalPages = page.pagination.totalPages
        //                    self.comments.append(contentsOf: page.items)
        //                    self.commentsItems.append(contentsOf: self.createCommentsItems(page.items))
        //                case .failure(let error):
        //                    print("error getting comments: \(error.localizedDescription)")
        //                    if !self.comments.isEmpty {
        //                        self.payload.pageNumber -= 1
        //                    }
        //                }
        //            }
        //            .store(in: &subscriptions)
        //
        //        didLoad
        //            .sink { [weak self] in
        //                guard let self = self else { return }
        //                self.isLoadingComments = true
        //                self.getComments.send()
        //                if let comment = self.currentlyReplyingOnComment {
        //                    self.newCommentPlaceholder = self.replyPlaceholder + comment.user.name
        //                    self.isCommentFocused = true
        //                }
        //            }
        //            .store(in: &subscriptions)
        //
        //        didScrollToBottom
        //            .sink { [weak self] in
        //                guard let self = self else { return }
        //                let shouldSkip = self.isLoadingComments || self.isLoadingCommentsNextPage || self.payload.pageNumber == self.totalPages
        //                guard !shouldSkip else { return }
        //                self.isLoadingCommentsNextPage = true
        //                self.payload.pageNumber += 1
        //                self.getComments.send()
        //            }
        //            .store(in: &subscriptions)
        //
        //        $newCommentText
        //            .map { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        //            .filter { _ in self.selectedCommentOrReplay == nil}
        //            .removeDuplicates()
        //            .assign(to: &$isSendAvailable)
        //
        //        $newCommentText
        //            .map { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        //            .filter { _ in self.selectedCommentOrReplay != nil}
        //            .removeDuplicates()
        //            .assign(to: &$isUpdateAvailable)
        //
        //        // add new comment
        //        addComment
        //            .handleOutput { [weak self] in
        //                guard let self = self else { return }
        //                self.sendingComments.enqueue(-(self.sendingComments.count + 1))
        //                self.addNewComment(body: $0)
        //                self.newCommentText.removeAll()
        //            }
        //            .asyncMap { await self.commentsRepo.addComment(payload: .init(body: $0, itemId: self.id, itemType: .newsFeed)) }
        //            .receive(on: RunLoop.main)
        //            .sink { [weak self] result in
        //                guard let self = self else { return }
        //                switch result {
        //                case .success(let item):
        //                    // update comments count & set comment id
        //                    self.post?.commentsCount += 1
        //                    self.updateComments(id: .id(item.id))
        //                    self.shouldUpdateComments = true
        //                    _ = self.sendingComments.dequeue()
        //                case .failure(let error):
        //                    print("error adding comment: \(error.localizedDescription)")
        //                    self.updateComments(id: .now)
        //                    _ = self.sendingComments.dequeue()
        //                }
        //            }
        //            .store(in: &subscriptions)
        //
        //        // update comment
        //        updateComment
        //            .handleOutput { [weak self] in
        //                guard let self = self else { return }
        //                self.updateComment(id: $0.id, body: $0.body)
        //                self.newCommentText.removeAll()
        //                self.selectedCommentOrReplay = nil
        //            }
        //            .asyncMap { await self.commentsRepo.updateComment(payload: .init(body: $0.body, id: $0.id, itemType: .newsFeed)) }
        //            .receive(on: RunLoop.main)
        //            .sink { [weak self] result in
        //                guard let self = self else { return }
        //                switch result {
        //                case .success:
        //                    // update comments count & set comment id
        //                    self.shouldUpdateComments = true
        //                case .failure(let error):
        //                    print("error adding comment: \(error.localizedDescription)")
        //                }
        //            }
        //            .store(in: &subscriptions)
        //
        //        // delete comment
        //        deleteComment
        //            .handleOutput { [weak self] in
        //                guard let self = self else { return }
        //                self.removeComment(id: $0.id)
        //                self.selectedCommentOrReplay = nil
        //                self.post?.commentsCount -= 1
        //                self.showToast = true
        //            }
        //            .asyncMap { await self.commentsRepo.deleteComment(payload: .init(id: $0.id, itemType: .newsFeed)) }
        //            .receive(on: RunLoop.main)
        //            .sink { [weak self] result in
        //                guard let self = self else { return }
        //                switch result {
        //                case .success:
        //                    // update comments count & set comment id
        //                    self.shouldUpdateComments = true
        //                case .failure(let error):
        //                    print("error adding comment: \(error.localizedDescription)")
        //                }
        //            }
        //            .store(in: &subscriptions)
        //
        //        // add reply
        //        addReply
        //            .handleOutput { [weak self] in
        //                guard let self = self else { return }
        //                self.sendingReplies.enqueue(-(self.sendingReplies.count + 1))
        //                self.addNewReply(body: $0)
        //                self.willDismissKeyboard.send()
        //            }
        //            .asyncMap { await self.commentsRepo.addReply(payload: .init(
        //                body: $0,
        //                itemId: self.replyingOnComments.tail?.id ?? 0,
        //                itemType: .newsFeed
        //            )) }
        //            .receive(on: RunLoop.main)
        //            .sink { [weak self] result in
        //                guard let self = self else { return }
        //                switch result {
        //                case .success(let item):
        //                    self.updateReplies(id: .id(item.id))
        //                    _ = self.sendingReplies.dequeue()
        //                    _ = self.replyingOnComments.dequeue()
        //                case .failure(let error):
        //                    print("error adding reply: \(error.localizedDescription)")
        //                    self.updateReplies(id: .now)
        //                    _ = self.sendingReplies.dequeue()
        //                    _ = self.replyingOnComments.dequeue()
        //                }
        //            }
        //            .store(in: &subscriptions)
        //
        //        addReaction
        //            .asyncMap { await self.commentsRepo.addReaction(payload: .init(
        //                itemId: $0.id,
        //                itemType: 1,
        //                reactionType: $0.type
        //            )) }
        //            .sink { [weak self] result in
        //                guard let self = self else { return }
        //                switch result {
        //                case .success(let reactions):
        //                    print("successfully adding reaction: \(reactions)")
        //                    self.shouldUpdateComments = true
        //                case .failure(let error):
        //                    print("error adding reaction: \(error.localizedDescription)")
        //                }
        //            }
        //            .store(in: &subscriptions)
        //
        //        didTapOnSend
        //            .map { self.newCommentText }
        //            .sink { [weak self] in
        //                guard let self = self else { return }
        //                if let replyingOnComment = self.currentlyReplyingOnComment {
        //                    self.replyingOnComments.enqueue(replyingOnComment)
        //                    self.addReply.send($0)
        //                } else {
        //                    self.addComment.send($0)
        //                }
        //                self.setAnalyticsEvent(
        //                    event: AnalyticsEvents.comment,
        //                    parameters: [CommentParam.postId: self.post?.id ?? 0]
        //                )
        //            }
        //            .store(in: &subscriptions)
        //
        //
        //        willDismissKeyboard
        //            .sink {
        //                self.newCommentPlaceholder = self.commentPlaceholder
        //                // reset replying
        //                if self.currentlyReplyingOnComment != nil {
        //                    self.currentlyReplyingOnComment = nil
        //                    self.newCommentText.removeAll()
        //                }
        //            }
        //            .store(in: &subscriptions)
        //
        //    }
        //
        //    // MARK: - Functions
        //    @MainActor
        //    func getPostById(postId: Int) async {
        //        let response = await repo.getPostByID(postId: postId)
        //        switch response {
        //        case .success(let postResponse):
        //            self.post = postResponse
        //        case .failure:
        //            handleError()
        //        }
        //    }
        //
        //    func likeItem() async {
        //        post?.userReactionType = post?.userReactionType == 1 ? 0 : 1
        //        if enableLikeReactionAPICall {
        //            await putLike()
        //        }
        //    }
        //
        //    private func createCommentsItems(_ comments: Comments, isSending: Bool = false) -> [CommentItem] {
        //        var items: [CommentItem] = []
        //        for comment in comments {
        //
        //            let reactionsVMs: [ReactionCountViewModel] = [
        //                .init(
        //                    id: comment.reactions.first?.type.rawValue ?? 0,
        //                    count: comment.reactions.first?.count ?? 0,
        //                    isSelected: comment.reactions.first?.type == comment.userReactionType,
        //                    selectedImage: Icon.likeFilled.rawValue,
        //                    unselectedImage: Icon.likeUnfilled.rawValue,
        //                    onTapAction: { isSelected in
        //                        self.addReaction.send((comment.id, isSelected ? .like : .none))
        //                        self.updateCommentReaction(id: comment.id, reaction: isSelected ? .like : .none)
        //                        self.shouldUpdateComments = true
        //                    }
        //                ),
        //                .init(
        //                    id: 99,
        //                    count: comment.repliesCount,
        //                    isSelected: false,
        //                    isIncremental: false,
        //                    selectedImage: MedSultoImageName.comment,
        //                    unselectedImage: MedSultoImageName.comment,
        //                    onTapAction: { [weak self] _ in
        //                        guard let self = self else { return }
        //                        self.newCommentPlaceholder = self.replyPlaceholder + comment.user.name
        //                        self.isCommentFocused = true
        //                    }
        //                )
        //            ]
        //
        //            let commentVM: CommentViewModel = .init(
        //                id: comment.id,
        //                authorImage: comment.user.profilePicture,
        //                hasReplies: comment.replies.count > 0,
        //                comment: .init(
        //                    author: comment.user.name,
        //                    subSpecialites: comment.user.subSpecialties.prefix(3).joined(separator: " | "),
        //                    body: comment.body,
        //                    date: comment.creationDate.asTimeInterval(format: .ago),
        //                    hasMenu: comment.user.id == user?.id,
        //                    reactionsVMs: reactionsVMs,
        //                    isSending: isSending,
        //                    onMenuTap: {
        //                        self.didTapOnActionMenu(commentOrReplay: comment)
        //                    },
        //                    onAuthorTap: { [weak self] in
        //                        guard let self = self else { return }
        //                        self.setAnalyticsForOpenUserProfile(
        //                            fullName: comment.user.name,
        //                            userType: self.user?.userType.name ?? "",
        //                            specialityName: comment.user.specialty,
        //                            source: UserBriefProfileDestination.post.rawValue
        //                        )
        //                        self.showCommentUserProfile(id: comment.user.id)
        //                    }
        //                )
        //            )
        //
        //            var repliesVMs: [ReplyViewModel] = []
        //
        //            for reply in comment.replies {
        //
        //                repliesVMs.append(.init(
        //                    id: reply.id,
        //                    authorImage: reply.user.profilePicture,
        //                    hasNext: reply.id != comment.replies.last?.id,
        //                    reply: .init(
        //                        author: reply.user.name,
        //                        subSpecialites: reply.user.subSpecialties.prefix(3).joined(separator: " | "),
        //                        body: reply.body,
        //                        date: reply.creationDate.asTimeInterval(format: .ago),
        //                        hasMenu: reply.user.id == "No Actions now on replaies",
        //                        reactionsVMs: [],
        //                        isSending: reply.id < 1,
        //                        onMenuTap: {
        //                        },
        //                        onAuthorTap: {
        //                            // TODO: Open comment.user profile
        //                            self.showCommentUserProfile(id: comment.user.id)
        //                        }
        //                    )
        //                ))
        //            }
        //
        //            items.append(.init(vm: commentVM, replies: repliesVMs))
        //
        //        }
        //        return items
        //    }
        //
        //    private func createNewComment(id: Int, body: String) -> Comment {
        //        return .init(
        //            id: id,
        //            creationDate: "\(Date().timeIntervalSince1970)",
        //            user: .init( // from profile
        //                id: user?.id ?? "",
        //                name: user?.fullName ?? "",
        //                profilePicture: user?.profilePicture ?? "",
        //                specialty: "",
        //                subSpecialties: user?.subSpecialities ?? []
        //                       ),
        //            body: body,
        //            reactions: [],
        //            userReactionType: .none,
        //            repliesCount: 0,
        //            replies: []
        //        )
        //    }
        //
        //    /// Use this method to add a new comment & comment item to comments & commentsItems ordered sets
        //    /// - Parameter body: new comment body
        //    private func addNewComment(body: String) {
        //        /// creating a new comment with the body and a negative id from sendingComments queue
        //        let comment: Comment = self.createNewComment(id: self.sendingComments.tail ?? -1, body: body)
        //        /// inserting the new comment into comments ordered set at the begining
        //        self.comments.insert(comment, at: 0)
        //        /// creating a new commentsItem with the new comment and inserting it into commentsItems ordered set
        //        if let commentsItem = self.createCommentsItems([comment], isSending: true).first {
        //            self.commentsItems.insert(commentsItem, at: 0)
        //        }
        //    }
    }
}
