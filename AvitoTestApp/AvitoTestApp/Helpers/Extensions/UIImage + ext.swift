//
//  UIImage + ext.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 26.08.2023.
//

import UIKit

extension UIImage {
	
	// Жалко проект в figma не дали)
	
	static var house: UIImage {
		return UIImage(systemName: "house")!
	}
	
	static var suitHeart: UIImage {
		return UIImage(systemName: "suit.heart")!
	}
	
	static var suitHeartFill: UIImage {
		return UIImage(systemName: "suit.heart.fill")!
	}
	
	static var sales: UIImage {
		return UIImage(systemName: "plus.square.on.square")!
	}
	
	static var chat: UIImage {
		return UIImage(systemName: "message")!
	}
	
	static var profile: UIImage {
		return UIImage(systemName: "person")!
	}
	
	static var ellipsis: UIImage {
		return UIImage(systemName: "ellipsis")!
	}
	
	static var defaultImage: UIImage {
		UIImage(systemName: "photo")!
	}
	
	static var backArrow: UIImage {
		UIImage(systemName: "arrow.backward")!
	}
	
	static var phoneFill: UIImage {
		UIImage(systemName: "phone.fill")!
	}
	
	static var chatFill: UIImage {
		UIImage(systemName: "message.fill")!
	}
	
}
