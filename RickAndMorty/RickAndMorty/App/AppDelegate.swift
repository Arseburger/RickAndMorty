//
//  AppDelegate.swift
//  RickAndMorty
//
//  Created by Александр Королёв on 17.07.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let vc = UINavigationController(rootViewController: MainViewController())
        vc.setupNavigationBar()
        window?.rootViewController = vc
        URLCache.shared = .init(memoryCapacity: 6 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, directory: nil)
        
        return true
    }
}

