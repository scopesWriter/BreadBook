//
//  FeedPostView.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

struct FeedPostView: View {
    // MARK: - Poperties
    @StateObject var post: FeedItem
    let commentsItems: [Comments]
    let showWriteCommentSection: Bool
    // MARK: - Bindings
    @State var hasLimit: Bool = true
    @State var chosenIndex = 0
    @State var showVideo = false
    @State var videoUrl: URL?
    @State var isPlaceholder: Bool = false
    
    // MARK: - Body
    var body: some View {
        HStack {
            Spacer().frame(width: 20)
            ZStack {
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 15) {
                        if post.activityLogType != nil &&
                            post.activityLogType != .creation &&
                            post.activityLogType != .empty {
                            UserActivityTypeView(activityLogType:
                                                    "\(ActivityUserWrapper.shared.activityUser.getActivityType(type: post.activityLogType!)) post",
                                                 activityLogTime: post.activityLogTime ?? "")
                                .padding(.top, 8)
                            
                            Divider()
                        }
                        titleView
                        contentView
                        if !isPlaceholder {
                            bottomView
                        }
                        
                    }
                    commentsSection
                   
                    if showWriteCommentSection {
                        FeedWriteCommentView()
                            .padding(.top, 5)
                    }
                }
            }
            .padding(.top, 20)
            .padding(.bottom, isPlaceholder ? 0 : 10)
            .background(Color.originalWhite)
            .clipShape(RoundedRectangle(cornerRadius: 15.0))
            .shadow(color: Color.cardShadow, radius: 16, x: 0, y: 8)
            .padding(.bottom)
            
            Spacer().frame(width: 20)
            
        }
        
    }
    
    // MARK: - Helper views
    // MARK: Title View
    private var titleView: some View {
        HStack {
                Spacer().frame(width: 20)
            
            HStack(alignment: .top) {
                NetworkImageView(withURL: post.authorImage,
                                 imageHeight: 28,
                                 aspectRatio: false,
                                 backgroundColor: Color.background,
                                 placeholderImageName: Icon.profilePlaceholderImage.rawValue)
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())
                    .gesture(
                        TapGesture().onEnded({ _ in
//                            if (post.authorId != user?.user?.id) {
//                                viewProfileAction()
//                            }
                        })
                    )
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    HStack {
                        Text(post.authorName)
                            .font(BreadBookFont.createFont(weight: .bold, size: 14))
                            .foregroundColor(Color.originalBlack)
                            .gesture(
                                TapGesture().onEnded({ _ in
//                                    if (post.authorId != user?.user?.id) {
//                                        viewProfileAction()
//                                    }
                                })
                            )
                        
                        Spacer()
                        
                        if post.activityLogType == .empty {
                            Button {
                                print("Option Action")
                            } label: {
                                Image(Icon.moreOption.rawValue)
                                    .renderingMode(.template)
                                    .foregroundColor(.originalBlack)
                            }
                            .frame(width: 50)
                            .padding(.trailing, -20)
                        }
                    }
                    
                    Text(post.subSpecialties?.joined(separator: " | ") ?? "")
                        .font(BreadBookFont.createFont(weight: .regular, size: 10))
                        .foregroundColor(Color.neutral600)
                        .lineLimit(1)
                    
                    Text(Date(timeIntervalSince1970: post.creationDate.convertToTimeInterval()).timeAgoDisplay())
                        .font(BreadBookFont.createFont(weight: .regular, size: 10))
                        .foregroundColor(Color.neutral600)
                }
            }
                Spacer(minLength: 0)
            
            Spacer().frame(width: 20)
        }
    }
    
    // MARK: Content View
    private var contentView: some View {
        VStack {
            if post.type == .postWithTextOnly ||
                post.type == .postWithMediaAndText {
                HStack {
                    Spacer().frame(width: 20)
                    TruncatingText(post.text, lineLimit: 2, hasLinks: true)
                        .font(BreadBookFont.createFont(weight: .regular, size: 12))
                        .foregroundColor(Color.originalBlack)
                    Spacer(minLength: 20)
                }
                Spacer().frame(height: post.type == .postWithTextOnly ? 10 : 25)
                              
            }
            if post.type == .postWithMediaAndText ||
                post.type == .postWithMediaOnly {
                let media = post.mediaList
                if !media.isEmpty {
                    if media[0].mediaTypeId == .image {
                        if media.count == 1 {
                            NetworkImageView(withURL: media[0].mediaUrl,
                                             aspectRatio: false,
                                             isClipped: true)
                            .frame(maxHeight: UIScreen.main.bounds.width - 20)
                            .contentShape(Rectangle())
                            .clipped()
                            .overlay(Color.clear)
                            
                        } else {
                            TabView(selection: $chosenIndex) {
                                ForEach(Array(zip(post.mediaList.indices, post.mediaList)), id: \.0) { index, media in
                                    NetworkImageView(
                                        withURL: media.mediaUrl,
                                        aspectRatio: false,
                                        isClipped: true
                                    )
                                    .contentShape(Rectangle())
                                    .clipped()
                                    .overlay(Color.clear)
                                    .tag(index)
                                }
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            .frame(height: UIScreen.main.bounds.width - 20)
                            
                        }
                    } else {
                        // Video
                        if media.count > 0 {
                            Button {
                                videoUrl = URL(string: "\(media[0].mediaUrl)\(AppConstants.streamingFormat)")
                                showVideo = true
                            } label: {
                                ZStack {
                                    NetworkImageView(withURL: media[0].thumbnailUrl,
                                                     aspectRatio: false,
                                                     isClipped: true
                                    )
                                    .frame(maxHeight: UIScreen.main.bounds.width - 20)
                                    .clipped()
                                    .overlay(Color.clear)
                                    HStack {
                                        Spacer()
                                        Image(Icon.playVideo.rawValue)
                                            .resizable()
                                            .frame(width: 50, height: 50, alignment: .center)
                                        Spacer()
                                    }
                                }
                            }
                            .frame(maxHeight: UIScreen.main.bounds.width - 20)
                            .contentShape(Rectangle())
                            .clipped()
                            .overlay(Color.clear)
                                ZStack {}
                                    .fullScreenCover(isPresented: $showVideo) {
//                                        AVPlayerView(videoURL: self.$videoUrl)
//                                            .edgesIgnoringSafeArea(.all)
                                    }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Bottom View
    private var bottomView: some View {
        HStack(spacing: 0) {

            HStack {
                // reactions & comments
                HStack(alignment: .center, spacing: 10) {
                    ReactionCountView(
                        style: .medium,
                        viewModel: .init(
                            id: 1,
                            count: post.reactions?.first(where: { $0.reactionType == 1 })?.count ?? 0,
                            isSelected: (post.userReactionType == 1),
                            selectedImage: Icon.likeFilled.rawValue,
                            unselectedImage: Icon.likeUnfilled.rawValue,
                            onTapAction: { _ in }
                        )
                    )
                    .accessibility(identifier: "")
                    
                    ReactionCountView(
                        style: .medium,
                        viewModel: .init(
                            id: 2,
                            count: post.commentsCount ?? 0,
                            isSelected: false,
                            isIncremental: false,
                            selectedImage: Icon.comment.rawValue,
                            unselectedImage: Icon.comment.rawValue,
                            onTapAction: { _ in
                                
                            }
                        )
                    )
                    .allowsHitTesting(false)
                    .accessibility(identifier: "")
                    
                }
                
                Spacer()
            }
            
            if post.mediaList.count > 1 && post.type != .postWithTextOnly {
                HStack(spacing: 3) {
                    ForEach(0..<post.mediaList.count) { j in
                        Circle()
                            .fill(chosenIndex == j ? Color.primary: Color.neutral400)
                            .frame(width: 6, height: 6)
                    }
                }
                Spacer()
            }
            
            HStack {
                Spacer()
                Button(action: {}, label: {
                    Image(post.isBookmarked ? Icon.bookmarkFilled.rawValue
                          : Icon.bookmarkUnfilled.rawValue)
                        .resizable()
                        .frame(width: 27, height: 27)
                        .foregroundColor(Color.originalBlack)

                })
            }
            
        }
        .padding(.horizontal, 15)
    }
        
    private var commentsSection: some View {
        VStack(spacing: 0) {
//            ForEach(commentsItems) { item in
//                // comment
//                VStack(spacing: 0) {
//                    Color.neutral200
//                        .frame(height: 1)
//                        .padding(.top, 10)
//                    CommentView(viewModel: item.vm)
//                }
//                .id("\(item.id)-\(item.vm.comment.reactionsVMs.map { $0.count })-\(item.vm.comment.body)")
//                // replies
//                ForEach(item.replies) { replyVM in
//                    ReplyView(viewModel: replyVM)
//                }
//            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
}

struct FitToAspectRatio: ViewModifier {
    
    let aspectRatio: Double
    let contentMode: SwiftUI.ContentMode
    
    func body(content: Content) -> some View {
        Color.clear
            .aspectRatio(aspectRatio, contentMode: .fit)
            .overlay(
                content.aspectRatio(nil, contentMode: contentMode)
            )
            .clipShape(Rectangle())
    }
    
}

extension Image {
    func fitToAspect(_ aspectRatio: Double, contentMode: SwiftUI.ContentMode) -> some View {
        self.resizable()
            .scaledToFill()
            .modifier(FitToAspectRatio(aspectRatio: aspectRatio, contentMode: contentMode))
    }
}

