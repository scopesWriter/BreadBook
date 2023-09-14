//
//  ReactionCountView.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

struct ReactionCountView: View {
    let style: Style
    @ObservedObject var viewModel: ReactionCountViewModel
    
    var body: some View {
        Button(action: viewModel.toggle) {
            HStack(alignment: .center, spacing: 2) {
                Image(viewModel.isSelected ? viewModel.selectedImage : viewModel.unselectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: style.size.icon, height: style.size.icon)
                    .foregroundColor(.originalBlack)
                    .unredacted()
                
                if viewModel.count > 0 {
                    Text("\(viewModel.count)")
                        .font(BreadBookFont.createFont(weight: .regular, size: style.size.font))
                        .foregroundColor(Color.originalBlack)
                        .frame(minWidth: 10)
                }
            }
        }
        .allowsHitTesting(!viewModel.isTapDisabled)
    }
}

struct ReactionCountView_Previews: PreviewProvider {
    static var previews: some View {
        ReactionCountView(
            style: .small,
            viewModel: .init(
                id: 1,
                count: 10,
                isSelected: false,
                selectedImage: Icon.likeFilled.rawValue,
                unselectedImage: Icon.likeUnfilled.rawValue,
                onTapAction: { _ in
                    print("reaction tapped!")
                }
            )
        )
        .previewLayout(.sizeThatFits)
    }
}

extension ReactionCountView {
    enum Style {
        case small
        case medium
        
        var size: (icon: CGFloat, font: CGFloat) {
            switch self {
            case .small:
                return (20, 8)
            case .medium:
                return (27, 10)
            }
        }
    }
}
