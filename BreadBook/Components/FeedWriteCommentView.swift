//
//  FeedWriteCommentView.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation
import SwiftUI

struct FeedWriteCommentView: View {
    
    var body: some View {
        writeCommentView
    }
    
    private var writeCommentView: some View {
        // write a comment text view
        HStack(alignment: .top, spacing: 5) {
            // user profile image
            NetworkImageView(
                withURL: "",
                imageHeight: 28,
                imageWidth: 28,
                renderingMode: .original,
                contentMode: .fill,
                placeholderImageName: Icon.profilePlaceholderImage.rawValue
            )
            .clipShape(Circle())
            .padding(.top, 4)
            
            // textView
            VStack {
                HStack {
                    Text("Write a comment..")
                        .foregroundColor(Color.originalBlack).opacity(0.5)
                    Spacer()
                }
                .padding(.horizontal, 5)
                .padding(.top, 11)
                
                Spacer()
            }
            .padding(.horizontal, 10)
            .background(Color.background)
            .addBorder(Color.neutral300, width: 1, cornerRadius: 17.5)
            .frame(minHeight: 35, maxHeight: 85)
            
        }
        .font(BreadBookFont.createFont(weight: .regular, size: 12))
        .padding(.horizontal, 18)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
    }

}

