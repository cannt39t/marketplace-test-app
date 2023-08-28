//
//  PhotoDetailViewController.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 28.08.2023.
//

import UIKit
import SDWebImage

final class PhotoDetailViewController: BaseController {
	
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	var imageURL: String?
	
	init(imageURL: String?) {
		super.init(nibName: nil, bundle: nil)
		self.imageURL = imageURL
		hidesBottomBarWhenPushed = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func loadImage(from URLString: String?) {
		guard let imageURLString = URLString, let imageURL = URL(string: imageURLString) else {
			imageView.image = .defaultImage.withRenderingMode(.alwaysOriginal).withTintColor(.label2.withAlphaComponent(0.25))
			return
		}
		imageView.sd_setImage(with: imageURL, placeholderImage: nil, options: [.highPriority])
	}
	
}

extension PhotoDetailViewController {
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.hidesBarsOnTap = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.hidesBarsOnTap = false
	}
	
}

@objc extension PhotoDetailViewController {
	
	private func shareTapped() {
		guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else { return }
		let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
		vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(vc, animated: true)
	}
	
}

extension PhotoDetailViewController {
	
	override func setupViews() {
		super.setupViews()
		
		view.setupView(imageView)
	}
	
	override func constraintViews() {
		super.constraintViews()
		
		NSLayoutConstraint.activate([
			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
	
	override func configureAppearance() {
		super.configureAppearance()
		
		navigationItem.largeTitleDisplayMode = .never
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
		view.backgroundColor = .black
		
		loadImage(from: imageURL)
	}
	
}
