//
//  NetworkImageView.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation
import SwiftUI

struct NetworkImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    var height: Double?
    var width: Double?
    var renderingMode: Image.TemplateRenderingMode?
    var foreGroundColor: Color?
    var contentMode: ContentMode
    var aspectRatio: Bool
    var backgroundColor: Color
    var placeholderImageName: String
    var isImageEnabledToBePresented: Bool
    var isClipped: Bool
    @State private var isImagePresented = false
    
    init(withURL url: String,
         imageHeight height: Double? = nil,
         imageWidth width: Double? = nil,
         renderingMode: Image.TemplateRenderingMode? = .original,
         foreGroundColor: Color?=nil,
         contentMode: ContentMode = .fit,
         aspectRatio: Bool = true,
         backgroundColor: Color = Color.neutral300,
         placeholderImageName: String = Icon.noImage.rawValue,
         isImageEnabledToPresented: Bool = false,
         isClipped: Bool = false,
         completion: @escaping (Data?)-> Void = {_ in}
    ) {
        imageLoader = ImageLoader(urlString: url, placeholderImageName: placeholderImageName, completion: completion)
        self.height = height
        self.width = width
        self.foreGroundColor = foreGroundColor
        self.renderingMode = renderingMode
        self.contentMode = contentMode
        self.aspectRatio = aspectRatio
        self.backgroundColor = backgroundColor
        self.placeholderImageName = placeholderImageName
        self.isImageEnabledToBePresented = isImageEnabledToPresented
        self.isClipped = isClipped
    }
    
    var body: some View {
        if let height = height {
            if let width = width {
                createImageView()
                    .frame(width: width, height: height)
            } else {
                createImageView()
                    .frame(height: height)
            }
        } else if isClipped {
            createImageView()
                .scaledToFill()
                .clipped()
        } else {
            createImageView()
        }
    }
    
    func createImageView() -> some View {
        let initialImageView =
        Image(uiImage: imageLoader.image ?? UIImage())
            .resizable()
            .renderingMode(renderingMode)
            .foregroundColor(foreGroundColor)
            .background(backgroundColor)
            .onTapGesture {
                
                isImagePresented = true
                
            }
            .fullScreenCover(isPresented: $isImagePresented) {
                if let image = imageLoader.image {
                    ImageViewerView(image: Image(uiImage: image),
                                    isImagePresented: $isImagePresented)
                }
            }
            .disabled(!isImageEnabledToBePresented)
        
        if aspectRatio {
            return AnyView(initialImageView
                .aspectRatio(contentMode: contentMode))
        } else {
            return AnyView(initialImageView)
        }
        
    }
    
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    var urlString: String?
    var placeholderImageName: String
    var imageCache = ImageCache.getImageCache()
    var completion: (Data?) -> Void
    
    init(urlString: String?,
         placeholderImageName: String,
         completion: @escaping(Data?) -> Void
    ) {
        if let urlString = urlString, urlString.contains("?") {
            self.urlString = String(urlString.split(separator: "?")[0])
        } else {
            self.urlString = urlString?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        }
        self.placeholderImageName = placeholderImageName
        self.completion = completion
        
        loadImage()
    }
    
    func loadImage() {
        if loadImageFromCache() {
            return
        }
        loadImageFromUrl()
    }
    
    func loadImageFromCache() -> Bool {
        guard let urlString = urlString else {
            return false
        }
        
        guard let cacheImage = imageCache.get(forKey: urlString) else {
            return false
        }
        
        image = cacheImage
        return true
    }
    
    func loadImageFromUrl() {
        guard let urlString = urlString else {
            self.image = UIImage(named: placeholderImageName)
            return
        }
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:))
            task.resume()
        }
        else {
            self.image = UIImage(named: placeholderImageName)
        }
    }
    
    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        
        guard error == nil, let data = data, let loadedImage = UIImage(data: data) else {
            DispatchQueue.main.async {
                self.image = UIImage(named: self.placeholderImageName)
            }
            return
        }
        
        completion(data)
        
        DispatchQueue.main.async {
            self.imageCache.set(forKey: self.urlString!, image: loadedImage)
            self.image = loadedImage
        }
    }
}

class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
