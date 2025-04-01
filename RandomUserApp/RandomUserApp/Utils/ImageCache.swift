//
//  Untitled.swift
//  RandomUserApp
//
//  Created by walid on 31/3/2025.
//
import Foundation
import UIKit

class ImageCache {
    private let cache = NSCache<NSString, UIImage>()

    func getImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        let urlString = url.absoluteString
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            completion(cachedImage)
        } else {
            downloadImage(from: url, completion: completion)
        }
    }

    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url, completion: { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            self?.cache.setObject(image, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async {
                completion(image)
            }
        }).resume()
    }
}
