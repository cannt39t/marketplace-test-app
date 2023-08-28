//
//  TabBarStrings.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 25.08.2023.
//

import UIKit

enum TabBarStrings {
	
	static func getTabTitle(tab: TabBarViewController.Tabs) -> String {
		switch tab {
		case .catalog: return CatalogString.tabTitle.localized
		case .favorites: return FavoritesString.tabTitle.localized
		case .sales: return SalesString.tabTitle.localized
		case .chat: return MessangerString.tabTitle.localized
		case .profile: return ProfileString.tabTitle.localized
		}
	}
	
	private enum CatalogString: String {
		case tabTitle
		
		var localized: String {
			NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
		}
	}
	
	private enum FavoritesString: String {
		case tabTitle
		
		var localized: String {
			NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
		}
	}
	
	private enum SalesString: String {
		case tabTitle
		
		var localized: String {
			NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
		}
	}
	
	private enum MessangerString: String {
		case tabTitle
		
		var localized: String {
			NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
		}
	}
	
	private enum ProfileString: String {
		case tabTitle
		
		var localized: String {
			NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
		}
	}
}

enum Search: String {
	case placeHolder
	case inTheCityOf
	
	var localized: String {
		NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
	}
}

enum Place: String {
	case showButton
	
	var localized: String {
		NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
	}
}

enum Call: String {
	case button
	
	var localized: String {
		NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
	}
}

enum Message: String {
	case button
	
	var localized: String {
		NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
	}
}


enum Decription: String {
	case header
	
	var localized: String {
		NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
	}
}

enum Viewed: String {
	case advCell
	
	var localized: String {
		NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
	}
}

enum SomethingWentWrong: String {
	case label
	
	var localized: String {
		NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
	}
}

enum Repeat: String {
	case button
	
	var localized: String {
		NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
	}
}
