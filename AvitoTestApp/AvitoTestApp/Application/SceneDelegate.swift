//
//  SceneDelegate.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 25.08.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let scene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: scene)
		window.rootViewController = TabBarViewController()
		self.window = window
		window.makeKeyAndVisible()
	}

}

