//
//  SceneDelegate.swift
//  tip-calculator
//
//  Created by Terry Jason on 2024/3/6.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window: UIWindow = UIWindow(windowScene: windowScene)
        let vc = CalculatorVC()
        
        window.rootViewController = vc
        
        self.window = window
        window.makeKeyAndVisible() 
    }
    
}

