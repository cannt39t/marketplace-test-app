//
//  BaseCollectionController.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 26.08.2023.
//

import UIKit

class BaseCollectionController: UICollectionViewController {
	
	private lazy var loader = UIActivityIndicatorView(style: .medium)
	var state: ScreenState = .CONTENT
	
	override func loadView() {
		super.loadView()
		
		setupViews()
		constraintViews()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureAppearance()
	}
	
}

extension BaseCollectionController {
	
	func showLoader() {
		view.isUserInteractionEnabled = false
		loader.startAnimating()
	}
	
	func hideLoader() {
		view.isUserInteractionEnabled = true
		loader.stopAnimating()
	}
	
}

@objc extension BaseCollectionController {
	
	func setupViews() {
		view.setupView(loader)
	}
	
	func constraintViews() {
		NSLayoutConstraint.activate([
			loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
	
	func configureAppearance() {
		view.backgroundColor = .background
		loader.hidesWhenStopped = true
	}
	
}

