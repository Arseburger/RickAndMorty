//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Александр Королёв on 17.07.2024.
//

import UIKit

extension UINavigationController {
    func setupNavigationBar() {
        let appearence = UINavigationBarAppearance()
        appearence.titleTextAttributes = [
            .foregroundColor : UIColor.white,
            .font : IBMPlexSans.getFont(weight: .bold, of: 24.0),
            .backgroundColor : UIColor.clear
        ]
        appearence.backgroundColor = .black
        
        navigationBar.standardAppearance = appearence
        navigationBar.compactAppearance = appearence
        navigationBar.scrollEdgeAppearance = appearence
        navigationBar.backgroundColor = .black
        navigationBar.tintColor = .white
    }
}

extension UIImageView {
    func loadImage(from url: String) -> DispatchWorkItem? {
        var workItem: DispatchWorkItem?
        let copyWorkItem = ImageLoader.shared.load(url: url) { image in
            guard let image = image else {
                return
            }

            if let workItem = workItem, workItem.isCancelled {
                return
            }

            DispatchQueue.main.async {
                self.image = image
            }
        }
        workItem = copyWorkItem
        return workItem
    }
}

final class ImageLoader {
    static let shared = ImageLoader()

    private let queue = DispatchQueue(label: "com.rick_morty.imageloader", qos: .userInteractive)

    func load(url: String, completion: @escaping (UIImage?) -> Void) -> DispatchWorkItem {
        let workItem = DispatchWorkItem {
            guard let url = URL(string: url) else { return }
            
            let cache = URLCache.shared
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
            
            if let imageData = cache.cachedResponse(for: request)?.data {
                completion(UIImage(data: imageData))
            } else {
                
                let session = URLSession.shared
                let task = session.dataTask(with: request) { data, response, _ in
                    guard let data = data, let response = response else { return }
                    let cacheRepsonse = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cacheRepsonse, for: request)
                    completion(UIImage(data: data))
                }
                task.resume()
            }
        }

        queue.async(execute: workItem)
        return workItem
    }
}

extension  String {
    func stringAfterLast(_ char: String) -> String {
        guard self.contains(char), char.count == 1 else { return "" }
        let charIndex = self.lastIndex(of: String.Element.init(char))!
        let nextIndex = self.index(after: charIndex)
        let result = self[nextIndex...]
        return String(result)
    }
}
