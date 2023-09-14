//
//  CommentBubbleView.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

struct CommentBubbleView: View {
    @StateObject var viewModel: CommentBubbleViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            VStack(alignment: .leading, spacing: 1) {
                
                HStack(alignment: .top) {
                    Text(viewModel.author)
                        .font(BreadBookFont.createFont(weight: .medium, size: 12))
                        .foregroundColor(Color.originalBlack)
                        .padding(.top, 6)
                        .onTapGesture(perform: viewModel.onAuthorTap)
                    
                    Spacer()
                    if viewModel.hasMenu {
                        Button(action: viewModel.onMenuTap) {
                            Image(Icon.horizontalMenu.rawValue)
                                .frame(width: 18, height: 18)
                        }
                        .unredacted()
                    }
                    
                }
                
                if !viewModel.subSpecialites.isEmpty {
                    Text(viewModel.subSpecialites)
                        .font(BreadBookFont.createFont(weight: .regular, size: 10))
                        .foregroundColor(Color.neutral600)
                }
                
                if viewModel.isSending {
                    Text("Sending...")
                        .font(BreadBookFont.createFont(weight: .regular, size: 10))
                        .foregroundColor(Color.neutral600)
                        .padding(.top, 3)
                   
                } else {
                    Text(viewModel.date)
                        .font(BreadBookFont.createFont(weight: .regular, size: 8))
                        .foregroundColor(Color.neutral600)
                        .padding(.top, 3)
                }
            }
                                       
            TruncatingText(viewModel.body, lineLimit: 2)
                .font(BreadBookFont.createFont(weight: .regular, size: 10))
                .foregroundColor(Color.originalBlack)
            
            HStack(alignment: .center, spacing: 10) {

                    Spacer()
                    
                    ForEach(viewModel.reactionsVMs) { reactionVM in
                        ReactionCountView(style: .small, viewModel: reactionVM)
                    }
                    
                
            }
            .frame(minHeight: ReactionCountView.Style.small.size.icon)
            .padding(.top, 4)
            
        }
        .padding(.horizontal, 15)
        .padding(.top, 10)
        .padding(.bottom, 15)
        .background(Color.neutral100)
        .cornerRadius(15)
    }
}

struct CommentBubbleView_Previews: PreviewProvider {
    
    static let vm: CommentBubbleViewModel = {
        var vm = CommentBubbleViewModel.example
        vm.isSending = true
        return vm
    }()
    
    static var previews: some View {
        Group {
            CommentBubbleView(viewModel: .example)
                .previewLayout(.sizeThatFits)
            
            CommentBubbleView(viewModel: vm)
                .previewLayout(.sizeThatFits)
        }
        
    }
}
