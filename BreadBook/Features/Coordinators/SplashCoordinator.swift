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
    
    // Splash
    @Root var start = makeSplash
    private func makeSplash() -> some View {
        SplashScreenView()
    }
    
    // Main Tap
    @Root var mainTab = makeMainTab
    private func makeMainTab() -> MainTabCoordinator {
        MainTabCoordinator()
    }
    
    @discardableResult
    func routeToMainTab() -> MainTabCoordinator {
        let coordinator = self.root(\.mainTab)
        return coordinator
    }
    
    deinit {
        print("Deinit SplashCoordinator")
    }
}
