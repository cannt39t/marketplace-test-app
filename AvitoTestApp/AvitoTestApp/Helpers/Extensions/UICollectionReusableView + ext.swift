//
//  UICollectionReusableView.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 25.08.2023.
//

import UIKit

extension UICollectionReusableView {
	
	static var identifier: String {
		.init(describing: self)
	}
	
}
