//
//  BaseController.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 25.08.2023.
//

import UIKit

enum ScreenState: Int {
	case ERROR, LOADING, CONTENT
}

class BaseController: UIViewController, UIGestureRecognizerDelegate {
	
	let loader = UIActivityIndicatorView(style: .medium)
	var state: ScreenState = .CONTENT
	
	override func loadView() {
		super.loadView()
		
		setupViews()
		constraintViews()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureAppearance()
		navigationController?.interactivePopGestureRecognizer?.delegate = self
		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
	}
	
}

extension BaseController {
	
	func showLoader() {
		view.isUserInteractionEnabled = false
		loader.startAnimating()
	}
	
	func hideLoader() {
		view.isUserInteractionEnabled = true
		loader.stopAnimating()
	}
	
}

@objc extension BaseController {
	
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
