//
//  PostDetailsView.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

import SwiftUI

// swiftlint:disable type_body_length
struct PostDetailsView: View {
    
    // MARK: - Poperties
    var postId: Int
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @StateObject var viewModel: PostViewModel
    let writeCommentBottomPadding: CGFloat = 70
    @State private var shouldNavigateToReferPatient: Bool = false
    @State private var shouldNavigateToReferPatientFromComments: Bool = false
    // MARK: - Bindings
    @State var chosenIndex = 0
    @State private var postAuthorId: String = ""
    
    // MARK: - init
    init(
        postId: Int,
        viewModel: @autoclosure @escaping () -> PostViewModel
    ) {
        self.postId = postId
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
                            
                            if viewModel.post != nil {
                                
                                LazyVStack(spacing: 0) {
                                    bottomView
                                        .padding(.bottom, 5)
                                        .padding(.horizontal, 20)
                                    
                                    EmptyView()
                                        .id("commentsSection")
//                                    ForEach(viewModel.commentsItems) { item in
//                                        // comment
//                                        VStack(spacing: 0) {
//                                            Color.neutral200
//                                                .frame(height: 1)
//                                                .padding(.top, 10)
//                                            //CommentView(viewModel: item.vm)
//                                        }
//                                        .id("\(item.id)-\(item.replies.count)-\(item.vm.comment.body)")
//                                        // replies
//                                        ForEach(item.replies) { replyVM in
//                                            ReplyView(viewModel: replyVM)
//                                                .id("\(replyVM.id)-\(replyVM.hasNext)-\(replyVM.reply.body)")
//                                        }
//                                    }
                                    
                                    ZStack {
//                                        if viewModel.isLoadingComments || viewModel.isLoadingCommentsNextPage {
//                                            VStack(spacing: 0) {
//                                                Color.neutral200
//                                                    .frame(height: 1)
//                                                    .padding(.top, 10)
//
//                                                CommentView(viewModel: .example)
//                                                    .redacted(reason: .placeholder)
//                                            }
//                                        }
                                        EmptyView()
                                    }
                                    .onAppear {
                                        viewModel.didScrollToBottom.send()
                                    }
                                    
                                    Spacer(minLength: 120)
                                    
                                }
                                //.addUUID()
                            }
                        }
                    }
                    
                    // write a comment text view
//                    if viewModel.userIsNotStudent() {
//
//                        VStack(alignment: .leading) {
//                            HStack(alignment: .bottom, spacing: 5) {
//                                // user profile image
//                                NetworkImageView(
//                                    withURL: viewModel.user?.profilePicture ?? "",
//                                    imageHeight: 28,
//                                    imageWidth: 28,
//                                    renderingMode: .original,
//                                    contentMode: .fill,
//                                    placeholderImageName: Icon.profilePlaceholderImage.rawValue
//                                )
//                                .clipShape(Circle())
//                                .padding(.bottom, 4)
//
//                                // textView
//                                ZStack(alignment: .leading) {
//                                    if viewModel.newCommentText.isEmpty {
//                                        VStack {
//                                            HStack {
//                                                Text(viewModel.newCommentPlaceholder)
//                                                    .foregroundColor(Color.black).opacity(0.5)
//                                                Spacer()
//                                            }
//                                            .padding(.horizontal, 5)
//                                            .padding(.top, 11)
//
//                                            Spacer()
//                                        }
//                                        .allowsHitTesting(false)
//                                    }
//                                    if #available(iOS 16, *) {
//                                        commentTextEditor
//                                            .focused(state: $viewModel.isCommentFocused)
//                                            .scrollContentBackground(.hidden)
//                                    } else if #available(iOS 15, *) {
//                                        commentTextEditor
//                                            .focused(state: $viewModel.isCommentFocused)
//                                    } else {
//                                        commentTextEditor
//                                    }
//
//                                }
//                                .padding(.horizontal, 10)
//                                .background(Color.background)
//                                .addBorder(Color.neutral300, width: 1, cornerRadius: 17.5)
//                                .frame(minHeight: 35, maxHeight: 85)
//
//                                // send button
//                                if viewModel.isSendAvailable {
//                                    Button {
//                                        viewModel.didTapOnSend.send()
//                                        guard viewModel.sendingComments.count > 0 else { return }
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                                            withAnimation {
//                                                proxy.scrollTo("commentsSection", anchor: .top)
//                                            }
//                                        }
//                                    } label: {
//                                        Image(Icon.send.rawValue)
//                                            .renderingMode(.original)
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 28, height: 28)
//                                    }
//                                    .padding(.bottom, 4)
//                                }
//
//                            }
//                            .font(BreadBookFont.createFont(weight: .regular, size: 12))
//
//                            if viewModel.isUpdateAvailable {
//                                HStack {
//                                    Spacer()
//
//                                    Button {
//                                        viewModel.newCommentText.removeAll()
//                                        viewModel.isCommentFocused = false
//                                        viewModel.selectedCommentOrReplay = nil
//                                    } label: {
//                                        Text("Cancel")
//                                            .font(BreadBookFont.createFont(weight: .regular, size: 14))
//                                            .foregroundColor(Color.black)
//                                    }
//
//                                    Spacer()
//                                        .frame(width: 140)
//
//                                    Button {
//                                        viewModel.didTapOnUpdate.send()
//                                    } label: {
//                                        Text("Update")
//                                            .font(BreadBookFont.createFont(weight: .bold, size: 14))
//                                            .foregroundColor(Color.black)
//                                    }
//
//                                    Spacer()
//                                }
//                                .padding(.vertical, 12)
//                            }
//
//                        }
//                        .padding(.horizontal, 18)
//                        .padding(.vertical, 8)
//                        .padding(.bottom, 0)
//                        .frame(maxWidth: .infinity)
//                        .fixedSize(horizontal: false, vertical: true)
//                        .background(Color.neutral200)
//                    }
                }
            }
            
            if viewModel.errorType != .noError {
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        ErrorView(type: viewModel.errorType) {
                            fetchData()
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
                //Toast(
                //    alertImageName: Icon.alert.rawValue,
                //    text: "",
                //    stillAppear: $viewModel.showToast ,
                //    backGroundColor: Color.success,
                //    onTapAction: { viewModel.showToast = false },
                //    appearingDurationInSeconds: 2,
                //    closingButtonAccessibilityId: ""
                //)
                //.padding(.horizontal, 10)
                //.padding(.bottom, 10)
                //.frame(maxHeight: .infinity, alignment: .bottom)
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
            fetchData()
            viewModel.didLoad.send()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            viewModel.willDismissKeyboard.send()
        }
    }
    
    // MARK: - Comment Text Editor
    private var commentTextEditor: some View {
        TextEditor(text: $viewModel.newCommentText)
            .lineSpacing(2)
            .accentColor(Color.primary)
            .autocapitalization(.none)
            .padding(.top, 2)
            .opacity(viewModel.newCommentText.isEmpty ? 0.25 : 1)
            .onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
    }
    
    // MARK: Title View
    private var titleView: some View {
        HStack {
            HStack(alignment: .top) {
                NetworkImageView(withURL: viewModel.post?.title ?? "",
                                 imageHeight: 28,
                                 aspectRatio: false,
                                 backgroundColor: Color.background,
                                 placeholderImageName: Icon.profilePlaceholderImage.rawValue
                )
                .frame(width: 28, height: 28)
                .clipShape(Circle())
                .gesture(
                    TapGesture().onEnded({ _ in
                        //viewModel.openProfileBottomSheet()
                    })
                )
                Spacer().frame(width: 10)
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .center, spacing: 0) {
                        //Text(viewModel.post?.title ?? "John Doe")
                        Text("John Doe")
                            .font(BreadBookFont.createFont(weight: .bold, size: 14))
                            .foregroundColor(Color.black)
                            .gesture(
                                TapGesture().onEnded({ _ in
                                    //viewModel.openProfileBottomSheet()
                                })
                            )
                        Spacer(minLength: 1)
                        
                        //                        Text(Date(timeIntervalSince1970: viewModel.post?.creationDate?.convertToTimeInterval() ?? 0).timeAgoDisplay())
                        //                            .font(BreadBookFont.createFont(weight: .regular, size: 10))
                        //                            .foregroundColor(Color.neutral600)
                        
                        Spacer()
                            .frame(width: 1)
                        
                        Button {
                            //viewModel.didTapOptions.send()
                        } label: {
                            Image(Icon.moreOption.rawValue)
                                .renderingMode(.template)
                                .foregroundColor(.originalBlack)
                        }
                        .frame(width: 50)
                        .padding(.trailing, -20)
                        
                    }
//                    if let subSpecialties = viewModel.post?.subSpecialties {
//                        TruncatingText(
//                            subSpecialties.joined(separator: " | "),
//                            lineLimit: 2
//                        )
//                        .font(BreadBookFont.createFont(weight: .regular, size: 12))
//                        .foregroundColor(Color.neutral600)
//                        .fixedSize(horizontal: false, vertical: true)
//                    } else {
                        Text("Dermatology | Gynocology | Diabetes")
//                    }
                    
                }
                
            }
            .redacted(reason: viewModel.post == nil ? .placeholder : [])
            
            Spacer().frame(width: 20)
            
        }
    }
    
    // MARK: Content View
    private var contentView: some View {
        VStack(alignment: .leading) {
//            if viewModel.post?.type == .postWithTextOnly ||
//                viewModel.post?.type == .postWithMediaAndText {
//                LinkedText(viewModel.post?.text ?? "")
//                    .font(BreadBookFont.createFont(weight: .regular, size: 12))
//                    .foregroundColor(Color.originalBlack)
//                    .fixedSize(horizontal: false, vertical: true)
//                Spacer().frame(height: 25)
//
//            }
//            if viewModel.post?.type == .postWithMediaAndText ||
//                viewModel.post?.type == .postWithMediaOnly {
//                if let media = viewModel.post?.mediaList, !media.isEmpty {
//                    if media[0].mediaTypeId == .image {
//                        if media.count == 1 {
//                            NetworkImageView(withURL:  media[0].mediaUrl ?? "", aspectRatio: true, isImageEnabledToPresented: true)
//
//                        }
//                    }
//                }
//            }
        }
    }
    
    // MARK: Bottom View
    private var bottomView: some View {
        
        // reactions & comments
        HStack(alignment: .center, spacing: 0) {
//            ReactionCountView(
//                style: .medium,
//                viewModel: .init(
//                    id: 1,
//                    count: viewModel.post?.reactions?.first(where: { $0.reactionType == 1 })?.count ?? 0,
//                    isSelected: (viewModel.post?.userReactionType == 1),
//                    selectedImage: Icon.likeFilled.rawValue,
//                    unselectedImage: Icon.likeUnfilled.rawValue,
//                    onTapAction: { _ in
//                        //Task {
//                        //    await viewModel.likeItem()
//                        //}
//                    }
//                )
//            )
//            .accessibility(identifier: "ButtonLike")
            Spacer()
            // page index
//            if viewModel.post?.mediaList.count ?? 0 > 1 {
//                HStack(spacing: 3) {
//                    ForEach(0..<(viewModel.post?.mediaList.count ?? 0)) { j in
//                        Circle()
//                            .fill(chosenIndex == j ? Color.primary: Color.neutral400)
//                            .frame(width: 6, height: 6)
//                    }
//                }
//            }
            Spacer()
//            ReactionCountView(
//                style: .medium,
//                viewModel: .init(
//                    id: 2,
//                    count: viewModel.post?.commentsCount ?? 0,
//                    isSelected: false,
//                    isIncremental: false,
//                    selectedImage: Icon.comment.rawValue,
//                    unselectedImage: Icon.comment.rawValue,
//                    onTapAction: { _ in
//                        if #available(iOS 15.0, *) {
//                            viewModel.isCommentFocused = true
//                        }
//                        viewModel.willDismissKeyboard.send()
//                    }
//                )
//            )
//            .accessibility(identifier: "buttonComment")
        }
        
    }
    
    private var navigationTrailingItems: some View {
        HStack(spacing: 20) {
            Button {
                //viewModel.shareDeepLink()
            } label: {
                Image(Icon.share.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }
            .accessibility(identifier: "buttonShare")
            
            Button {
                Task {
                    //await
                    //viewModel.bookmarkItem()
                }
            } label: {
//                Image((viewModel.post?.isBookmarked ?? false) ? MedSultoImageName.bookmarkWhiteFilled : MedSultoImageName.bookmark
//                )
//                .resizable()
//                .scaledToFit()
//                .frame(width: 24, height: 24)
//                .foregroundColor(.white)
            } .accessibility(identifier: "buttonBookMark")
            
            
        }
    }
    
    private func fetchData() {
        Task {
            //await viewModel.getPostById(postId: postId)
            //self.postAuthorId = viewModel.post?.authorID ?? ""
        }
    }
    
}
