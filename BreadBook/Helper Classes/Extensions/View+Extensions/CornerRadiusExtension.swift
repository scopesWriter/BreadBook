//
//  CornerRadiusExtension.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct ClipCorner: ViewModifier {
    
    enum Corners {
        case top
        case bottom
    }
    
    let radius: CGFloat
    let corners: Corners
    
    func body(content: Content) -> some View {
        switch corners {
        case .top:
            content
                .padding(.bottom, radius)
                .cornerRadius(radius)
                .padding(.bottom, -(radius + 5))
        case .bottom:
            content
                .padding(.top, radius)
                .cornerRadius(radius)
                .padding(.top, -radius)
        }
        
    }
}

extension View {
    func clipped(radius: CGFloat, corners: ClipCorner.Corners) -> some View {
        modifier(ClipCorner(radius: radius, corners: corners))
    }
}

struct RoundedEdge: ViewModifier {
    let width: CGFloat
    let color: Color
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content.cornerRadius(cornerRadius - width)
            .padding(width)
            .background(color)
            .cornerRadius(cornerRadius)
    }
}

extension View {
    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}
