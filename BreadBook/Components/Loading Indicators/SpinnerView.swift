//
//  SpinnerView.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

struct SpinnerConfiguration {
    var color: Color
    var width: CGFloat
    var height: CGFloat
    var lineWidth: CGFloat
    var speed: Double
    var delay: Double
    
    init(color: Color = .primary700,
         width: CGFloat = 50,
         height: CGFloat = 50,
         lineWidth: CGFloat = 6,
         speed: Double = 0.6,
         delay: Double = 0.4) {
        self.color = color
        self.width = width
        self.height = height
        self.lineWidth = lineWidth
        self.speed = speed
        self.delay = delay
    }
}

struct SpinnerView: View {
    var configuration: SpinnerConfiguration = SpinnerConfiguration()
    @State private var isAnimating = false
    
    var body: some View {
        
        ZStack {
            Circle()
                .trim(from: 0.75, to: 1)
                .stroke(
                    configuration.color,
                    style: StrokeStyle(
                        lineWidth: configuration.lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .frame(width: configuration.width, height: configuration.height, alignment: .center)
        }
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(Animation.linear(duration: configuration.speed)
                                .delay(configuration.delay)
                                .repeatForever(autoreverses: false)) {
                    self.isAnimating = true
                }
            }
            
        }
    }
}

struct SpinnerView_Previews: PreviewProvider {
    static var previews: some View {
        SpinnerView()
    }
}
