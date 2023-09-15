//
//  LinkedText.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI
import SafariServices

private let linkDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)

struct LinkColoredText: View {
    enum Component {
        case text(String)
        case link(String, URL)
    }
    
    let text: String
    let components: [Component]
    
    init(text: String, links: [NSTextCheckingResult]) {
        self.text = text
        let nsText = text as NSString
        
        var components: [Component] = []
        var index = 0
        for result in links {
            if result.range.location > index {
                components.append(.text(nsText.substring(with: NSRange(location: index, length: result.range.location - index))))
            }
            components.append(.link(nsText.substring(with: result.range), result.url!))
            index = result.range.location + result.range.length
        }
        
        if index < nsText.length {
            components.append(.text(nsText.substring(from: index)))
        }
        
        self.components = components
    }
    
    var body: some View {
        components.map { component in
            switch component {
            case .text(let text):
                return Text(verbatim: text)
            case .link(let text, _):
                return Text(verbatim: text)
                    .foregroundColor(.blue)
                    .underline()
            }
        }.reduce(Text(""), +)
    }
}

struct LinkedText: View {
    let text: String
    let links: [NSTextCheckingResult]
    let font: (name: BreadBookFontName, weight: BreadBookFontWeight, size: CGFloat)?
    
    init (_ text: String, font: (name: BreadBookFontName, weight: BreadBookFontWeight, size: CGFloat)? = nil) {
        self.text = text
        self.font = font
        let nsText = text as NSString
        
        // find the ranges of the string that have URLs
        let wholeString = NSRange(location: 0, length: nsText.length)
        links = linkDetector?.matches(in: text, options: [], range: wholeString) ?? []
    }
    
    var body: some View {
        LinkColoredText(text: text, links: links)
            .font(BreadBookFont.createFont(
                name: font?.name ?? .bwModelica,
                weight: font?.weight ?? .regular,
                size: font?.size ?? 12
            )) // enforce here because the link tapping won't be right if it's different
            .overlay(LinkTapOverlay(text: text, links: links, font: font))
            .onTapGesture { }
    }
}

private struct LinkTapOverlay: UIViewRepresentable {
    let text: String
    let links: [NSTextCheckingResult]
    let font: (name: BreadBookFontName, weight: BreadBookFontWeight, size: CGFloat)?
    
    func makeUIView(context: Context) -> LinkTapOverlayView {
        let view = LinkTapOverlayView()
        view.textContainer = context.coordinator.textContainer
        
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.didTapLabel(_:)))
        tapGesture.delegate = context.coordinator
        view.addGestureRecognizer(tapGesture)
        
        return view
    }
    
    func updateUIView(_ uiView: LinkTapOverlayView, context: Context) {
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .font: BreadBookUIFont.createFont(
                    name: font?.name ?? .bwModelica,
                    weight: font?.weight ?? .regular,
                    size: font?.size ?? 12
                )
            ])
        context.coordinator.textStorage = NSTextStorage(attributedString: attributedString)
        context.coordinator.textStorage!.addLayoutManager(context.coordinator.layoutManager)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        let overlay: LinkTapOverlay
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        var textStorage: NSTextStorage?
        
        init(_ overlay: LinkTapOverlay) {
            self.overlay = overlay
            
            textContainer.lineFragmentPadding = 0
            textContainer.lineBreakMode = .byWordWrapping
            textContainer.maximumNumberOfLines = 0
            layoutManager.addTextContainer(textContainer)
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            let location = touch.location(in: gestureRecognizer.view!)
            let result = link(at: location)
            return result != nil
        }
        
        @objc func didTapLabel(_ gesture: UITapGestureRecognizer) {
            let location = gesture.location(in: gesture.view!)
            guard let result = link(at: location) else {
                return
            }
            
            guard let url = result.url else {
                return
            }
            
            let safariVC = SFSafariViewController(url: url)
            safariVC.preferredControlTintColor = .white
            safariVC.preferredBarTintColor = UIColor(Color.primaryVariant)
            UIApplication.shared.windows.first?.rootViewController?.present(safariVC, animated: true)
        }
        
        private func link(at point: CGPoint) -> NSTextCheckingResult? {
            guard !overlay.links.isEmpty else {
                return nil
            }
            
            let indexOfCharacter = layoutManager.characterIndex(
                for: point,
                in: textContainer,
                fractionOfDistanceBetweenInsertionPoints: nil
            )
            
            return overlay.links.first { $0.range.contains(indexOfCharacter) }
        }
    }
}

private class LinkTapOverlayView: UIView {
    var textContainer: NSTextContainer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var newSize = bounds.size
        newSize.height += 20 // need some extra space here to actually get the last line
        textContainer.size = newSize
    }
}
