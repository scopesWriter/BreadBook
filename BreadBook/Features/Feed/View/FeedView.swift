//
//  FeedView.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

// swiftlint:disable type_body_length
struct FeedView: View {
    
    // MARK: - Bindings
    @StateObject var viewModel: FeedViewModel
    @State private var shouldShowSearch = true
    @State private var isAnimating = true
    @State private var reachedTop = false
    
    // MARK: - UI Constants
    let leftPadding: CGFloat = 20
    let rightPadding: CGFloat = 20
    var isClearSearch: ((Bool) -> Void)?
    var goBack: (() -> Void)?
    
    // MARK: - Init
    init(viewModel: @autoclosure @escaping () -> FeedViewModel,
         isClearSearch: ((Bool) -> Void)? = nil,
         goBack: (() -> Void)? = nil
    ) {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UITableView.appearance().showsVerticalScrollIndicator = false
        _viewModel = StateObject(wrappedValue: viewModel())
        self.isClearSearch = isClearSearch
        self.goBack = goBack
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            BreadBookBaseView {
                Color.pink.edgesIgnoringSafeArea(.all)
            }
            
            VStack(spacing: 0) {
                if shouldShowSearch {
                    Spacer().frame(height: 16)
                    if viewModel.searchKeyword == "" {
                        TopSearchViewBody
                    } else {
                        TopSearchViewBodyWithSearchKeyword
                    }
                    
                    Spacer().frame(height: 20)
                }
                ZStack {
                    ZStack {
                        VStack {
                            if viewModel.isInitialLoad {
                                loadingView
                            } else {
                                ScrollViewReader { proxy in
                                    feedListView
                                        .onReceive("\(Constants.scrollToTopOfViewNotificationName)\("Feed")") { _ in
                                            withAnimation { proxy.scrollTo("top") }
                                        }
                                }
                            }
                        }
                        
                        Spacer()
                        
                    }
                    if viewModel.errorType != .noError {
                        ZStack {
                            HStack {
                                Spacer()
                                VStack {
                                    Spacer()
                                    ErrorView(type: viewModel.errorType) {
                                        viewModel.isInitialLoad = true
                                        viewModel.errorType = .noError
                                        viewModel.didLoad.send()
                                    }
                                    Spacer()
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                        .background(Color.background)
                        .cornerRadius(viewModel.errorType != .noError ? 0 : 30, corners: [.topLeft, .topRight])
                        .edgesIgnoringSafeArea(.bottom)
                    }
                    
                }
                .background(Color.background)
                .cornerRadius(viewModel.errorType != .noError ? 0 : 30, corners: [.topLeft, .topRight])
                .edgesIgnoringSafeArea(.bottom)
                
            }
            .onAppear(perform: {
                
                NotificationCenter.default.post(
                    name: NSNotification.Name(Constants.bookmarksBottomSheetNotificationName),
                    object: nil,
                    userInfo: [Constants.bookmarksBottomSheetFlag: false]
                )
                
                if viewModel.shouldLoadData {
                    viewModel.didLoad.send()
                    viewModel.shouldLoadData = false
                }
                
                if viewModel.reflectSearchActions {
                    viewModel.didLoad.send()
                    viewModel.reflectSearchActions = false
                }
            })
            .background(Color.primaryVariant)
            .navigationBarHidden(true)
            .navigationBarTitle("", displayMode: .inline)
            
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
        .onLoad {
            self.viewModel.didLoad.send()
        }
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
    
    }
    
    // MARK: - Top View
    private var TopSearchViewBody: some View {
        VStack(alignment: .leading) {
            Button {
                viewModel.didTapOnSearch()
            } label: {
                ZStack(alignment: .trailing) {
                    SearchTextField("What are you looking for?", inputText: Binding<String>(get: {return ""}, set: { _ in}), onCommit: nil, trailingItem: {})
                        .disabled(true)
                }
            }.frame(height: 50)
                .buttonStyle(PlainButtonStyle())
            
        }
        .padding([.horizontal], 19)
    }
    
    private var TopSearchViewBodyWithSearchKeyword: some View {
        HStack(spacing: 0) {
            Button {
                if let goBack = goBack {
                    goBack()
                }
                print("back")
            } label: {
                Image(systemName: "chevron.backward")
                    .accentColor(.white)
            }.padding(10)
            
            VStack(alignment: .leading) {
                ZStack(alignment: .trailing) {
                    SearchTextField( "What are you looking for?",
                                     inputText: $viewModel.searchKeyword, onCommit: { }, shouldShowClear: false, trailingItem: {})
                    .disabled(true)
                    HStack {
                        Button {
                            if let goBack = goBack {
                                goBack()
                            }
                        } label: {
                            Text("")
                                .frame(maxWidth: .infinity, maxHeight: 30)
                        }
                        
                        Button {
                            print("clear search")
                            isClearSearch?(true)
                            if let goBack = goBack {
                                goBack()
                            }
                        } label: {
                            HStack {
                                Image(Icon.clearSearch.rawValue)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(10)
                            }
                        }.frame(height: 30)
                    }
                }
                .padding([.trailing], 20)
            }
        }
    }
    
    // MARK: - Feed List View
    private var feedListView: some View {
        return Group {
                ScrollView {
                    LazyVStack {
                        feedContentView
                    }
                }
        }
        .listStyle(.plain)
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture().onChanged({ value in
                if value.translation.height > 15 && self.reachedTop {
                    withAnimation(.easeInOut(duration: 1)) {
                        viewModel.pullToRefresh = true
                    }
                }
                print(value.translation.height)
                DispatchQueue.main.async {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        if value.translation.height > 10 {
                            self.shouldShowSearch = true
                        } else if value.translation.height < -5 {
                            self.shouldShowSearch = false
                        }
                    }
                }
            }))
    }
    
    private var feedContentView: some View {
        return Group {
            if viewModel.pullToRefresh ?? false {
                HStack {
                    Spacer()
                    SpinnerView(configuration: SpinnerConfiguration(
                        color: Color.primaryVariant2,
                        width: 30,
                        height: 30,
                        lineWidth: 4,
                        speed: 1,
                        delay: 0
                    ))
                    .onAppear {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        viewModel.refresh()
                    }
                    Spacer()
                }
                .padding()
            }
            
            VStack {
                
            }
            .onAppear {
                self.reachedTop = true
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.shouldShowSearch = true
                }
            }
            .onDisappear {
                self.reachedTop = false
            }
            .padding(.top, 20)
            .id("top")
            
            // MARK: - Feed Items
            ForEach(viewModel.items, id: \.id) { item in
                switch item {
                default: drawFeedItem(item: item)
                }
            }
            
            if viewModel.checkIfEmptySearch() {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        EmptySearchView(
                            title: "Unfortunately, your search is not found…",
                            subTitle: "Try searching for another term",
                            image: Icon.searchNotFound.rawValue)
                        Spacer()
                    }
                    Spacer()
                }
            }
            
            if viewModel.hasMoreData && viewModel.currentPage != 1 {
                HStack {
                    Spacer()
                    ActivityIndicator(isAnimating: $isAnimating, style: .medium)
                        .onAppear {
                            viewModel.didLoad.send()
                        }
                        .opacity(viewModel.isInitialLoad ? 0:1)
                    Spacer()
                }
            }
            
            Spacer().frame(height: 100)
            
        }
        
    }

    func drawFeedItem(item: FeedViewModel.FeedItemViewModel) -> some View {
        Group {
            switch item {
            case .filters(let filters):
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(filters) { filter in
                            let isSelected = filter.id == viewModel.selectedFilterId
                            FilterChipsView(
                                state: isSelected ? FilterState.selected : FilterState.default,
                                isSelected: isSelected,
                                text: filter.text,
                                onTap: filter.onTap
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
                
            case .item(let item):
                self.createPostsSection([item], isFeatured: false)
            default: AnyView{}
            }
        }
    }
    
    func drawFiltersSection(_ filters: [FeedFilterViewModel]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(filters) { filter in
                    let isSelected = filter.id == viewModel.selectedFilterId
                    FilterChipsView(
                        state: isSelected ? FilterState.selected : FilterState.default,
                        isSelected: isSelected,
                        text: filter.text,
                        onTap: filter.onTap
                    )
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 20)
    }
    
    // MARK: - Sections' headers
    func createSectionHeader(
        title: String,
        titleAccessibilityId: String,
        viewAllAccessibilityId: String = "",
        viewAllAction: (() -> Void)?) -> some View {
            
            VStack {
                HStack {
                    Spacer().frame(width: leftPadding)
                    Text(title)
                        .font(BreadBookFont.createFont(weight: .bold, size: 14))
                        .foregroundColor(Color.originalBlack)
                        .accessibility(identifier: titleAccessibilityId)
                    Spacer()
                    if let viewAllAction = viewAllAction {
                        Button {
                            viewAllAction()
                        } label: {
                            HStack(spacing: 6) {
                                Text("View all")
                                    .font(BreadBookFont.createFont(weight: .regular, size: 12))
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(Color.originalBlack)
                        }
                        .accessibility(identifier: viewAllAccessibilityId)
                    }
                    Spacer().frame(width: rightPadding)
                    
                }
            }
        }
    
    // MARK: - Featured Posts Section
    private func createPostsSection(_ items: [FeedItem], isFeatured: Bool) -> some View {
        return ForEach(items, id: \.self) { item in
            let currentPost = item
                FeedPostView(
                    post: currentPost,
                    commentsItems: [],
                    showWriteCommentSection: viewModel.shouldShowWriteCommentSection
                )
                .fixedSize(horizontal: false, vertical: true)
                .onTapGesture {
                    viewModel.didTapOnPost(item: currentPost)
                }
                .listRowBackground(Color.clear)
        }
    }
    
    private var loadingView: some View {
        VStack {
            Spacer().frame(height: 20)
            
            HStack(spacing: 15) {
                ForEach(0...2, id: \.self) {_ in
                    FilterChipsView(
                        state: FilterState.default,
                        isSelected: false,
                        text: "Filter",
                        onTap: {}
                    )
                }
                Spacer()
            }.padding(.bottom, 20)
                .padding(.horizontal, 20)
            
            FeedPostView(post: viewModel.createDummyPost(withMedia: false), commentsItems: [], showWriteCommentSection: false, isPlaceholder: true)
            .fixedSize(horizontal: false, vertical: true)
            
            FeedPostView(post: viewModel.createDummyPost(withMedia: true), commentsItems: [], showWriteCommentSection: false, isPlaceholder: true)
            .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }.redacted(reason: .placeholder)
        
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(viewModel: FeedViewModel(withRepository: FeedRepository()))
    }
}
