//
//  TruncationText.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

struct TruncatingText: View {
    @State private var expanded: Bool = false
    @State private var truncated: Bool = false
    
    private var text: String
    private var lineLimit: Int
    private let hasLinks: Bool
    
    init(_ text: String, lineLimit: Int, hasLinks: Bool = false) {
        self.text = text
        self.lineLimit = lineLimit
        self.hasLinks = hasLinks
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                textView
                    .lineLimit(expanded ? nil : 2)
                    .fixedSize(horizontal: false, vertical: true)
                    .background(
                        textView
                            .lineLimit(lineLimit)
                            .background(GeometryReader { displayedGeometry in
                                ZStack {
                                    textView
                                        .background(GeometryReader { fullGeometry in
                                            Color.clear.onAppear {
                                                self.truncated = fullGeometry.size.height > displayedGeometry.size.height
                                            }
                                        })
                                }
                                .frame(height: .greatestFiniteMagnitude)
                            })
                            .hidden() // Hide the background
                    )
            }
            if truncated {
                HStack {
                    Spacer()
                    seeMoreLessButton
                        .accessibility(identifier: "BtnSeeMore")
                }
            }
        }
    }
    var seeMoreLessButton: some View {
        Button(action: {
                self.expanded.toggle()
        }) {
            Text(self.expanded ? "see less" : "...see more")
                .font(BreadBookFont.createFont(weight: .regular, size: 9))
                .foregroundColor(Color.primary)
        }
    }
    
    @ViewBuilder var textView: some View {
        if hasLinks {
            LinkedText(text)
        } else {
            Text(text)
        }
    }
    
}
