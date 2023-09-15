//
//  MainTapCoordinator.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI
import Stinsen

final class MainTabCoordinator: TabCoordinatable {
    
    var child: TabChild
    
    // MARK: - Init
    init() {
        Theme.navigationBarColors(background: UIColor(Color.mintGreen), titleColor: .white)
        
        self.child = {
            var paths: [AnyKeyPath] = []
            paths.append(contentsOf: [
                \MainTabCoordinator.feed
            ])
            return .init(startingItems: paths)
        }()
        setupTabBarAppearance()
    }
    
    deinit {
        print("Deinit MainTabCoordinator")
    }
    
    // Feed
    @Route(tabItem: makeFeedTab, onTapped: onFeedTapped) var feed = makeFeed
    @ViewBuilder private func makeFeedTab(isActive: Bool) -> some View {
        Image(Icon.feed.rawValue)
        Text("BreadFast")
    }
    private func makeFeed() -> NavigationViewCoordinator<FeedCoordinator> {
        NavigationViewCoordinator(FeedCoordinator())
    }
    
    // pop to root
    private func onFeedTapped(_ isRepeat: Bool, coordinator: NavigationViewCoordinator<FeedCoordinator>) {
        if isRepeat {
            if coordinator.child.stack.currentRoute == -1 {
                NotificationCenter.default.post(
                    name: Notification.Name(
                        "\(Constants.scrollToTopOfViewNotificationName)\("Feed")"),
                    object: nil
                )
            }
            coordinator.child.popToRoot()
        }
    }
    
    // MARK: - Setup appearance
    private func setupTabBarAppearance() {
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = UIColor(Color.mintGreen)
        itemAppearance.selected.iconColor = UIColor(Color.mintGreen)
        
        itemAppearance.normal.titleTextAttributes = [.font: BreadBookUIFont.createFont(weight: .medium, size: 12)]
        itemAppearance.selected.titleTextAttributes = [.font: BreadBookUIFont.createFont(weight: .medium, size: 12)]
        
        let shadowImage = UIImage.gradientImageWithBounds(
            bounds: CGRect(x: 0, y: 0, width: UIScreen.main.scale, height: 8),
            colors: [
                UIColor.clear.cgColor,
                UIColor.black.withAlphaComponent(0.05).cgColor
            ]
        )
        
        let appearance = UITabBarAppearance()
        appearance.selectionIndicatorTintColor = UIColor(Color.mintGreen)
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = .clear
        appearance.shadowImage = shadowImage
        appearance.backgroundColor = UIColor(Color.background)
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
}
