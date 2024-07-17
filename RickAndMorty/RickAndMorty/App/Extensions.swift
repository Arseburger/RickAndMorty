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
        self.navigationBar.standardAppearance = appearence
        self.navigationBar.compactAppearance = appearence
        self.navigationBar.scrollEdgeAppearance = appearence
        self.navigationBar.backgroundColor = .black
        self.navigationBar.tintColor = .white
        self.navigationItem.backButtonTitle = ""
    }
}
