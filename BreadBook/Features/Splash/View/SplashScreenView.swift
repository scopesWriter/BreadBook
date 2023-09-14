//
//  SplashScreenView.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

struct SplashScreenView: View {
    
    // MARK: - ViewModel
    @ObservedObject private var viewModel = SplashScreenViewModel()
    
    // MARK: - Body
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    BreadBookBaseView {
                        Color.pink.edgesIgnoringSafeArea(.all)
                    }
                    
                    breadBookAnimation
                    
                    if viewModel.errorType != .noError {
                        BreadBookAlertView(
                            viewModel: viewModel.createSplashScreenErrorViewModel(),
                            axis: viewModel.errorType == .connectionError ? .vertical : .horizontal)
                    }
                    
                }
                .opacity(viewModel.disappearingAnimation ? 0.8 : 1)
                .edgesIgnoringSafeArea([.all])
                .navigationBarHidden(true)
            }
            .background(Color.white.opacity(0.0001))
        }
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        
    }
    
    // MARK: Animation
    private var breadBookAnimation: some View {
        ZStack {
            LottieView(name: LottieViewName.splashScreen, loopMode: .playOnce, completion: { _ in
                self.viewModel.finishedFirstLoop = true
            })
            LottieView(name: LottieViewName.splashScreen,
                       loopMode: .loop, completion: nil)
            .background(Color.pink)
        }
    }
    
}

// MARK: - Preview
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
