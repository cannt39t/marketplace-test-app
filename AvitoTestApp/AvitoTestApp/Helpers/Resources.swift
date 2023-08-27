//
//  Resources.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 26.08.2023.
//

import UIKit

enum R {
	
	enum Image {
		static func getImageForTabBar(tab: TabBarViewController.Tabs) -> UIImage {
			switch tab {
			case .catalog: return .house
			case .favorites: return .suitHeart
			case .sales: return .sales
			case .chat: return .chat
			case .profile: return .profile
			}
		}

	}
	
}
