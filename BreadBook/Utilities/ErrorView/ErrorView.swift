//
//  ErrorView.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI
import Stinsen

struct ErrorView: View {
    let type: ErrorViewType
    let retryAction: () -> Void
    private let mainRouter: MainTabCoordinator.Router? = RouterStore.shared.retrieve()
    
    init(type: ErrorViewType,
         retryAction: @escaping () -> Void) {
        self.type = type
        self.retryAction = retryAction
    }
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            
            VStack(alignment: .center, spacing: 0) {
                Image(type.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 155, height: 195)
                
                Spacer().frame(height: 20)
                
                Text(type.title)
                    .font(BreadBookFont.createFont(weight: .bold, size: 14))
                    .foregroundColor(Color.originalBlack)
                    .padding(.bottom, 7)
                
                Text(type.subtitle)
                    .font(BreadBookFont.createFont(weight: .regular, size: 12))
                    .foregroundColor(Color.originalBlack)
                    .multilineTextAlignment(.center)
                    .frame(width: 212)
            }
            Spacer().frame(height: 35)
            
            Button {
                retryAction()
            } label: {
                Text(type.buttonTitle)
                    .font(BreadBookFont.createFont(weight: .bold, size: 14))
            }
            .frame(width: 98, height: 37)
            .foregroundColor(type == .connectionError ? Color.primary : Color.white)
            .background(type == .connectionError ? Color.clear : Color.pink)
            .clipShape(Capsule())
            .accessibility(identifier: "")
            
        }
    }
}

struct ConnectionErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(type: .technicalError, retryAction: {})
    }
}
