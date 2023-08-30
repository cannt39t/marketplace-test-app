//
//  MainTabBarController.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 25.08.2023.
//

import UIKit

final class TabBarViewController: UITabBarController {
	
	enum Tabs: Int, CaseIterable {
		case catalog, favorites, sales, chat, profile
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configure() {
		tabBar.tintColor = .primary
		tabBar.barTintColor = .background
		tabBar.backgroundColor = .background
		tabBar.layer.borderColor = UIColor.label2.withAlphaComponent(0.25).cgColor
		tabBar.layer.borderWidth = 1
		tabBar.layer.masksToBounds = true
		
		let controllers: [UIViewController] = Tabs.allCases.map { tab in
			let controller = UINavigationController(rootViewController: getController(for: tab))
			controller.tabBarItem = UITabBarItem(title: TabBarStrings.getTabTitle(tab: tab),
												 image: R.Image.getImageForTabBar(tab: tab),
												 tag: tab.rawValue)
			return controller
		}
		
		setViewControllers(controllers, animated: false)
	}
	
	private func getController(for tab: Tabs) -> UIViewController {
		switch tab {
		case .catalog: return CatalogViewController(nibName: nil, bundle: nil)
		case .favorites: return FavoritesViewController()
		case .sales: return SalesViewController()
		case .chat: return ChatViewController()
		case .profile: return ProfileViewController()
		}
	}
	
	func switchToTab(_ tab: Tabs) {
		selectedIndex = tab.rawValue
	}
	
}
