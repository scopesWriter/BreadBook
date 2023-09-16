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
        
        XCTAssertEqual(viewModel.testModel.count, 0,
                       "Popular feed posts count was expected to be 10, but was \(viewModel.items.count)")
        
    }
    
    @MainActor
    func testSuccessfulFeedItemsFetchFirstItemsDetails() async throws {
        await viewModel.repo.fetchNewsFeed()
        
        let firstItem = viewModel.testModel.first ?? .init(id: 0, userID: 0, title: "", body: "")
        
        XCTAssertEqual(firstItem.id, 0,
                       "First Item Id was expected to be 1, but was \(firstItem.id)")
        XCTAssertEqual(firstItem.userID, 0,
                       "First Item userID was expected to be 1, but was \(firstItem.userID)")
        XCTAssertEqual(firstItem.title, "",
                       "First Item title was expected to be Author1, but was \(firstItem.title)")
    }
    
}
