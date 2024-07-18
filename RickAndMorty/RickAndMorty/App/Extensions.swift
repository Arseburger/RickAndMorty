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
    func loadImage(from url: String) {
        guard let url = URL(string: url) else { return }
        
        let cache = URLCache.shared
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        if let imageData = cache.cachedResponse(for: request)?.data {
            
            self.image = UIImage(data: imageData)
            
        } else {
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, _ in
                DispatchQueue.main.async {
                    guard let data = data, let response = response else { return }
                    let cacheRepsonse = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cacheRepsonse, for: request)
                    self.image = UIImage(data: data)
                }
            }
            task.resume()
        }
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
