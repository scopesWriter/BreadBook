//
//  EmptySearchView.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

struct EmptySearchView: View {
    
    // MARK: properties
    let title: String
    let subTitle: String
    let image: String
    init(title: String, subTitle: String, image: String) {
        self.title = title
        self.subTitle = subTitle
        self.image = image
    }
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 135, height: 131)
                Text(title)
                    .font(BreadBookFont.createFont(weight: .regular, size: 14))
                    .foregroundColor(Color.black)
                if !subTitle.isEmpty {
                    Text(subTitle)
                        .font(BreadBookFont.createFont(weight: .medium, size: 14))
                        .foregroundColor(Color.black)
                }
                
            }
            .multilineTextAlignment(.center)
            .padding([.top,.horizontal], 30)
            Spacer()
        }
        
    }
}

struct EmptySearchView_Previews: PreviewProvider {
    static var previews: some View {
        EmptySearchView(
            title: "Unfortunately, your search is not found…",
            subTitle: "Try searching for another specialty.",
            image: "search not found")
    }
}
