//
//  Fonts.swift
//  RickAndMorty
//
//  Created by Александр Королёв on 17.07.2024.
//

import UIKit

enum IBMPlexSans: String {
    case regular = "Regular"
    case medium = "Medium"
    case semiBold = "SemiBold"
    case bold = "Bold"
    
    static func getFont(weight: IBMPlexSans, of size: CGFloat) -> UIFont {
        let name = "IBMPlexSans-" + weight.rawValue
        return UIFont(name: name, size: size) ?? .systemFont(ofSize: size)
    }
    
}
