//
//  SplashCoordinator.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI
import Stinsen

final class SplashCoordinator: NavigationCoordinatable {
    
    let stack = NavigationStack(initial: \SplashCoordinator.start)
    lazy var routerStorable: SplashCoordinator = self
    
    @Root var start = makeSplash
    private func makeSplash() -> some View {
        SplashScreenView()
    }
    
    @Root var mainTab = makeMainTab
    private func makeMainTab() -> MainTabCoordinator {
        MainTabCoordinator()
    }
    
    @discardableResult
    func routeToMainTab() -> MainTabCoordinator {
        let coordinator = self.root(\.mainTab)
        return coordinator
    }
    
    func showToast(_ viewModel: ToastyViewModel) {
        NotificationCenter.default.post(
            name: Notification.Name(Constants.toasty),
            object: nil,
            userInfo: [Constants.toastyViewModel: viewModel]
        )
    }
    
    func showNewToast(_ viewModel: ToastyViewModel) {
        NotificationCenter.default.post(
            name: Notification.Name(Constants.newToasty),
            object: nil,
            userInfo: [Constants.toastyViewModel: viewModel]
        )
    }
    
    func hideToast() {
        NotificationCenter.default.post(
            name: Notification.Name(Constants.hideToast),
            object: nil,
            userInfo: [:]
        )
    }
    
    deinit {
        print("Deinit SplashCoordinator")
    }
}
