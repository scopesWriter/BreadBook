//
//  ReplyView.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

struct ReplyView: View {
    @StateObject var viewModel: ReplyViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: -0.5) {
            
            Color.neutral200
                .opacity(viewModel.hasNext ? 1 : 0)
                .frame(width: 1.5)
            
            HStack(alignment: .top, spacing: -32) {
                Circle()
                    .rotation(.degrees(90))
                    .trim(from: 0, to: 0.25)
                    .stroke(Color.neutral200, style: .init(lineWidth: 1.8, lineCap: .round))
                    .frame(width: 72, height: 72)
                    .offset(y: -36)
                
                HStack(alignment: .top, spacing: 5) {
                    
                    NetworkImageView(
                        withURL: viewModel.authorImage,
                        imageHeight: 21,
                        imageWidth: 21,
                        renderingMode: .original,
                        contentMode: .fill,
                        placeholderImageName: Icon.profilePlaceholderImage.rawValue
                    )
                    .clipShape(Circle())
                    .padding(.top, 14)
                    .onTapGesture(perform: viewModel.reply.onAuthorTap)
                    
                    CommentBubbleView(viewModel: viewModel.reply)
                }
                .padding(.top, 10)
            }
            
        }
        .padding(.leading, 13)
        .padding(.horizontal, 20)
        
    }
}

struct ReplyView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            ReplyView(viewModel: .init(id: 1, authorImage: "", hasNext: true, reply: .example))
                .frame(height: 155)
            ReplyView(viewModel: .init(id: 2, authorImage: "", hasNext: false, reply: .example))
                .frame(height: 155)
        }
        
        .previewLayout(.sizeThatFits)
    }
}

