//
//  PhotoDetailViewController.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 28.08.2023.
//

import UIKit
import SDWebImage

final class PhotoDetailViewController: BaseController {
	
	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.minimumZoomScale = 1.0
		scrollView.maximumZoomScale = 3.0
		return scrollView
	}()
	
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
		state = .LOADING
		guard let imageURLString = URLString, let imageURL = URL(string: imageURLString) else {
			imageView.image = .defaultImage.withRenderingMode(.alwaysOriginal).withTintColor(.label2.withAlphaComponent(0.25))
			state = .ERROR
			return
		}
		imageView.sd_setImage(with: imageURL, placeholderImage: nil, options: [.highPriority]) { [weak self] image, error, _, _ in
			if error != nil {
				self?.state = .ERROR
				return
			}
			
			if image != nil {
				self?.state = .CONTENT
				return
			}
		}
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
		
		view.setupView(scrollView)
		scrollView.setupView(imageView)
	}
	
	override func constraintViews() {
		super.constraintViews()
		
		NSLayoutConstraint.activate([
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
			imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
		])
	}
	
	override func configureAppearance() {
		super.configureAppearance()
		
		navigationItem.largeTitleDisplayMode = .never
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
		view.backgroundColor = .black
		
		scrollView.delegate = self
		loadImage(from: imageURL)
	}
	
}

extension PhotoDetailViewController: UIScrollViewDelegate {
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	
}
