//
//  BreadBook App.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI
import Stinsen

@main
struct BreadBookAppLauncher {
    static func main() {
        Theme.navigationBarColors(background: UIColor(Color.mintGreen), titleColor: .white)
        Theme.removeListSeparators()
        BreadBookApp.main()
    }
}

@available(iOS 14.0, *)
struct BreadBookApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        // MARK: - Enable Netfox
        NetfoxHelper.shared.enableNetfox()
        // MARK: - Set Accent Color
        AccentColorSetter.setAccentColor()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationViewCoordinator(SplashCoordinator()).view()
                .environmentObject(appDelegate)
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
    }
    
}
