//
//  SplashScreenViewModel.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation
import SwiftUI
import Stinsen
import Combine

class SplashScreenViewModel: BaseViewModel, ObservableObject {
    
    // MARK: - Publishers
    @Published var disappearingAnimation = false
    @Published var finishedFirstLoop = false
    private var subscriptions = Set<AnyCancellable>()
    
    @RouterObject var router: NavigationRouter<SplashCoordinator>?
    
    // MARK: - Properties
    private let mainRouter: MainTabCoordinator.Router? = RouterStore.shared.retrieve()
    
    // MARK: - Init
    override init() {
        super.init()
        setupBinding()
    }
    
    // MARK: - Functions
    private func setupBinding() {
        $finishedFirstLoop
            .sink { [weak self] newValue in
                guard let self = self else { return }
                if newValue {
                    Task { await self.animateDisappearance() }
                    self.proceedFlow()
                }
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Proceed
    private func proceedFlow() {
        router?.coordinator.routeToMainTab()
    }
    
    // MARK: - Animate Disappearance
    @MainActor
    private func animateDisappearance() async {
        withAnimation(.linear(duration: 0.5)) {
            self.disappearingAnimation = true
        }
        try? await Task.sleep(nanoseconds: 0_400_000_000)
    }
    
    // MARK: - Error View In case API is loading and failed...
    func createSplashScreenErrorViewModel() -> BreadBookAlertViewModel {
        let retry = BreadBookAlertViewButton(
            title: errorType.buttonTitle,
            action: {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.errorType = .noError
                }
            }, accessibilityId: "",
            backgroundColor: errorType == .connectionError ? .clear : Color.primary,
            foregroundColor: errorType == .connectionError ? Color.primary : .white
        )
        if errorType == .connectionError {
            self.errorType = .noConnectionWithoutDrugs
        }
        return BreadBookAlertViewModel(title: errorType.title, subtitle: errorType.subtitle, buttons: [retry])
    }
    
}
