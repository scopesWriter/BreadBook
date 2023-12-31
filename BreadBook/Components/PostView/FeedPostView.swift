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
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    HStack {
                        Text(post.authorName)
                            .font(BreadBookFont.createFont(weight: .bold, size: 14))
                            .foregroundColor(Color.originalBlack)
                        
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
            if post.type == .postWithTextOnly {
                HStack {
                    Spacer().frame(width: 20)
                    TruncatingText(post.text, lineLimit: 2, hasLinks: true)
                        .font(BreadBookFont.createFont(weight: .regular, size: 12))
                        .foregroundColor(Color.originalBlack)
                    Spacer(minLength: 20)
                }
                Spacer().frame(height: post.type == .postWithTextOnly ? 10 : 25)
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

