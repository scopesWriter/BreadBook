//
//  Toast.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 15/09/2023.
//

import SwiftUI

struct Toast: View {
    let alertImageName: String
    var text: String
    @Binding var stillAppear: Bool?
    let backGroundColor: Color
    var onTapAction: (() -> Void )?
    let appearingDurationInSeconds: Double
    let closingButtonAccessibilityId: String
    var body: some View {
        
        HStack(spacing: 15) {
            Image(alertImageName)
                .resizable()
                .frame(width: 20, height: 20, alignment: .center)
            Text(text)
                .font(BreadBookFont.createFont(weight: .medium, size: 10))
                .foregroundColor(.white)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Button {
                stillAppear = false
            } label: {
                Image(Icon.close.rawValue)
                    .foregroundColor(.white)
            }.accessibility(identifier: closingButtonAccessibilityId)
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(backGroundColor)
        .cornerRadius(Style.CornerRadius.card)
        .shadow(color: Color.cardShadow, radius: 6, x: 0, y: 3)
        .onTapGesture(perform: onTapAction ?? {})
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + appearingDurationInSeconds) {
                if stillAppear == true { stillAppear = false }
            }
        }
    }
}

struct ToastViewModel {
    let alertImageName: String
    var text: String
    @Binding var stillAppear: Bool?
    let backGroundColor: Color
    var onTabAction: (() -> Void )?
    let appearingDurationInSeconds: Double
    let closingButtonAccessibilityId: String
}

struct Toast_Previews: PreviewProvider {
    static var previews: some View {
        Toast(alertImageName: Icon.alert.rawValue,
              text: "Make sure to complete your profile to experience all app features.",
              stillAppear: .constant(true),
              backGroundColor: Color.primary,
              onTapAction: {},
              appearingDurationInSeconds: 3,
              closingButtonAccessibilityId: " ")
    }
}

