//
//  BreadBook Alert view.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

struct BreadBookAlertView: View {
    
    // MARK: - Variables
    var viewModel: BreadBookAlertViewModel
    var axis: Axis
    @State var animation = false
    
    // MARK: - Init
    init(viewModel: BreadBookAlertViewModel, axis: Axis = .horizontal) {
        self.viewModel = viewModel
        self.axis = axis
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.black.opacity(viewModel.hasClearBackground ? 0 : !animation ? 0.7 :0.4)
            VStack {
                Spacer()
                AlertView(viewModel: viewModel, axis: axis)
                if self.animation {
                    Spacer()
                }
            }.edgesIgnoringSafeArea(.all)
        }.edgesIgnoringSafeArea(.all)
            .onAppear {
                withAnimation {
                    self.animation = true
                }
            }
    }
}

// MARK: - Preview
struct MedSultoAlertView_Previews: PreviewProvider {
    static var previews: some View {
        let buttons: [BreadBookAlertViewButton] = [BreadBookAlertViewButton(title: "OK", action: {
            print("Hello")
        }, accessibilityId: "")
        ]
        let alertViewModel = BreadBookAlertViewModel(title: "Title", subtitle: "Subtitle", buttons: buttons)
        
        BreadBookAlertView(viewModel: alertViewModel)
    }
}
