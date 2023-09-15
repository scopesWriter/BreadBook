//
//  PostDetailsView.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

// swiftlint:disable type_body_length
struct PostDetailsView: View {
    
    // MARK: - Poperties
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @StateObject var viewModel: PostViewModel
    let writeCommentBottomPadding: CGFloat = 70
    
    // MARK: - init
    init(
        viewModel: @autoclosure @escaping () -> PostViewModel
    ) {
        _viewModel = StateObject(wrappedValue: viewModel())
        UITextView.appearance().backgroundColor = .clear
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            postBodyView
                .background(Color.background)
                .navigationBarHidden(false)
                .navigationBarTitleDisplayMode(.inline)
            
            if viewModel.isLoading {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack {
                            SpinnerView(
                                configuration: SpinnerConfiguration(
                                    color: Color.primary700,
                                    lineWidth: 4,
                                    speed: 1,
                                    delay: 0
                                )
                            )
                        }
                        .frame(width: 85, height: 100)
                        .background(Color.background)
                        .cornerRadius(10)
                        
                        Spacer()
                    }
                    Spacer()
                }.background(Color.black.opacity(0.4))
            }
            
        }
        .navigationBarHidden(false)
        .navigationBarTitle("", displayMode: .inline)
        
    }
    
    private var postBodyView: some View {
        ZStack {
            ScrollViewReader { proxy in
                ZStack(alignment: .bottom) {
                    // content scroll view
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 15) {
                            Spacer().frame(height: 5)
                            Group {
                                titleView
                                contentView
                            }
                            .padding(.horizontal, 20)
                            
                            LazyVStack(spacing: 0) {
                                bottomView
                                    .padding(.bottom, 5)
                                    .padding(.horizontal, 20)
                                
                                EmptyView()
                                    .id("commentsSection")
                                
                                ForEach(viewModel.comments) { item in
                                    // comment
                                    VStack(spacing: 0) {
                                        Color.neutral200
                                            .frame(height: 1)
                                            .padding(.top, 10)
                                        CommentView(viewModel: item.vm)
                                    }
                                    .id("\(item.id)")
                                    
                                }
                                
                                ZStack {
                                    if viewModel.isLoadingComments {
                                        VStack(spacing: 0) {
                                            Color.neutral200
                                                .frame(height: 1)
                                                .padding(.top, 10)
                                            
                                            CommentView(viewModel: .example)
                                                .redacted(reason: .placeholder)
                                        }
                                    }
                                    EmptyView()
                                }
                                .onAppear {
                                    viewModel.didScrollToBottom.send()
                                }
                                
                                Spacer(minLength: 120)
                                
                            }
                            .addUUID()
                            
                        }
                    }
                }
            }
            
            if viewModel.errorType != .noError {
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        ErrorView(type: viewModel.errorType) {
                            viewModel.errorType = .noError
                        }
                        Spacer()
                        Spacer()
                    }
                    Spacer()
                }
                .background(Color.background)
            }
            
            if viewModel.showToast ?? false {
                Toast(
                    alertImageName: Icon.alert.rawValue,
                    text: "",
                    stillAppear: $viewModel.showToast ,
                    backGroundColor: Color.success,
                    onTapAction: { viewModel.showToast = false },
                    appearingDurationInSeconds: 2,
                    closingButtonAccessibilityId: ""
                )
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            
        }
        .clipShape(RoundedRectangle(cornerRadius: 0))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(
                action: {
                    self.mode.wrappedValue.dismiss()
                }, label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                            .accentColor(.white)
                        Text("Back")
                            .font(BreadBookFont.createFont(weight: .medium, size: 14))
                            .accentColor(.white)
                            .foregroundColor(.white)
                    }
                    .accessibility(identifier: "btn_back")
                }
            ),
            trailing: navigationTrailingItems
        )
        .onLoad {
            viewModel.didLoad.send()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            viewModel.willDismissKeyboard.send()
        }
    }
    
    // MARK: Title View
    private var titleView: some View {
        HStack {
            HStack(alignment: .top) {
                NetworkImageView(withURL: viewModel.post.title,
                                 imageHeight: 28,
                                 aspectRatio: false,
                                 backgroundColor: Color.background,
                                 placeholderImageName: Icon.profilePlaceholderImage.rawValue
                )
                .frame(width: 28, height: 28)
                .clipShape(Circle())
                .gesture(
                    TapGesture().onEnded({ _ in
                        print("Open Profile Tapped")
                    })
                )
                
                Spacer().frame(width: 10)
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    HStack(alignment: .center, spacing: 0) {
                        
                        Text(viewModel.post.title)
                            .font(BreadBookFont.createFont(weight: .bold, size: 14))
                            .foregroundColor(Color.black)
                        
                        Spacer(minLength: 1)
                        
                        Text(Date(timeIntervalSince1970: 0).timeAgoDisplay())
                            .font(BreadBookFont.createFont(weight: .regular, size: 10))
                            .foregroundColor(Color.neutral600)
                        
                        Spacer()
                            .frame(width: 1)
                        
                        Button {
                            print("Options Tapped")
                        } label: {
                            Image(Icon.moreOption.rawValue)
                                .renderingMode(.template)
                                .foregroundColor(.originalBlack)
                        }
                        .frame(width: 50)
                        .padding(.trailing, -20)
                    }
                }
                
            }
            .redacted(reason: viewModel.post == nil ? .placeholder : [])
            
            Spacer().frame(width: 20)
            
        }
    }
    
    // MARK: Content View
    private var contentView: some View {
        VStack(alignment: .leading) {
            LinkedText(viewModel.post.body)
                .font(BreadBookFont.createFont(weight: .regular, size: 12))
                .foregroundColor(Color.originalBlack)
                .fixedSize(horizontal: false, vertical: true)
            Spacer().frame(height: 25)
        }
    }
    
    // MARK: Bottom View
    private var bottomView: some View {
        
        // reactions & comments
        HStack(alignment: .center, spacing: 0) {
            ReactionCountView(
                style: .medium,
                viewModel: .init(
                    id: 1,
                    count: viewModel.comments.count,
                    isSelected: true,
                    selectedImage: Icon.likeFilled.rawValue,
                    unselectedImage: Icon.likeUnfilled.rawValue,
                    onTapAction: { _ in
                        print("Like Tapped")
                    }
                )
            )
            .accessibility(identifier: "ButtonLike")
            Spacer()
            ReactionCountView(
                style: .medium,
                viewModel: .init(
                    id: 2,
                    count: viewModel.comments.count,
                    isSelected: false,
                    isIncremental: false,
                    selectedImage: Icon.comment.rawValue,
                    unselectedImage: Icon.comment.rawValue,
                    onTapAction: { _ in
                        if #available(iOS 15.0, *) {
                            viewModel.isCommentFocused = true
                        }
                        viewModel.willDismissKeyboard.send()
                    }
                )
            )
            .accessibility(identifier: "buttonComment")
        }
        
    }
    
    private var navigationTrailingItems: some View {
        HStack(spacing: 20) {
            
            Button {
                print("Share Link Tapped")
            } label: {
                Image(Icon.share.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }
            .accessibility(identifier: "buttonShare")
            
            Button {
                print("Bookmark Tapped")
            } label: {
                Image(Icon.bookmarkUnfilled.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            } .accessibility(identifier: "buttonBookMark")
            
        }
    }
    
}
