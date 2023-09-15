//
//  FeedViewModelTests.swift
//  BreadBookTests
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//
import XCTest
@testable import BreadBook

class FeedViewModelTests: XCTestCase {
    
    var viewModel: FeedViewModel!
    var mockRepo: FeedRepositoryProtocol!
    
    override func setUpWithError() throws {
        mockRepo = FeedRepoMockSuccessfulFeed()
        viewModel = FeedViewModel(withRepository: mockRepo)
    }
    
    override func tearDownWithError() throws {
        mockRepo = nil
        viewModel = nil
    }
    
    // MARK: - feed items
    @MainActor
    func testSuccessfulFeedItemsFetchCount() async throws {
        await viewModel.repo.fetchNewsFeed()
        
        XCTAssertEqual(viewModel.items.count, 10,
                       "Popular feed posts count was expected to be 10, but was \(viewModel.items.count)")
        
    }
    
    @MainActor
    func testSuccessfulFeedItemsFetchFirstItemsDetails() async throws {
        await viewModel.repo.fetchNewsFeed()
        
        let firstItem = viewModel.items[0]
        
        XCTAssertEqual(firstItem.item.rawValue, 1,
                       "First Item Id was expected to be 1, but was \(firstItem.id)")
        XCTAssertEqual(firstItem.authorId, "1",
                       "First Item AuthorId was expected to be 1, but was \(firstItem.authorId)")
        XCTAssertEqual(firstItem.text, 0,
                       "First Item mediaList count was expected to be 0, but was \(firstItem.text)")
    }
    
}
