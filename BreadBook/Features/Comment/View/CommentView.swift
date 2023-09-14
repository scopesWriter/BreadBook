//
//  CommentView.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

import SwiftUI

struct CommentView: View {
    @StateObject var viewModel: CommentViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 5) {
            VStack(spacing: 5) {
                NetworkImageView(
                    withURL: viewModel.authorImage,
                    imageHeight: 28,
                    imageWidth: 28,
                    renderingMode: .original,
                    contentMode: .fill,
                    placeholderImageName: Icon.profilePlaceholderImage.rawValue
                )
                .clipShape(Circle())
                .padding(.top, 11)
                .onTapGesture(perform: viewModel.comment.onAuthorTap)
                
                if viewModel.hasReplies {
                    Color.neutral200
                        .frame(width: 1.7)
                        .cornerRadius(0.85)
                }
                
            }
            
            CommentBubbleView(viewModel: viewModel.comment)
            
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        
    }
}

struct CommentView_Previews: PreviewProvider {

    static var previews: some View {
        CommentView(viewModel: .example)
            .redacted(reason: .placeholder)
            .previewLayout(.sizeThatFits)
            .frame(height: 155)
    }
}
