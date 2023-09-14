//
//  NavigationAppearance.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

class Theme {
    static func navigationBarColors(background: UIColor?,
                                    titleColor: UIColor? = nil, tintColor: UIColor? = nil ) {
        
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = background ?? .clear
        navigationAppearance.shadowColor = .clear
        
        navigationAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black]
        navigationAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .black]
        
        var backImage: UIImage?
        if #available(iOS 14, *) {
            backImage = UIImage(named: "chevron.backward")
        } else {
            backImage = UIImage(named: Icon.backButton.rawValue)
        }
        navigationAppearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        
        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
        
        
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                .font : UIFont(
                    name: "\(BreadBookFontName.bwModelica.rawValue)-\(BreadBookFontWeight.medium.rawValue.capitalizingFirstLetter())",
                    size: 14
                ) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
            ],
            for: .normal
        )
        
    }
    
    static func removeListSeparators() {
        UITableView.appearance().sectionHeaderHeight = 0
        UITableView.appearance().sectionFooterHeight = 0
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().separatorColor = .clear
        UITableViewCell.appearance().backgroundColor = Color.background.uiColor()
        UITableView.appearance().backgroundColor = Color.background.uiColor()
    }
    
}

func removeNavBarDefaultTheme() {
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    UINavigationBar.appearance().shadowImage = UIImage()
}

func makeNavBarTransparent() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()

    UINavigationBar.appearance().standardAppearance = appearance
}
