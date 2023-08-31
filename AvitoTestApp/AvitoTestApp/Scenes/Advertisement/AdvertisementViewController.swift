//
//  AdvertisementViewController.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 27.08.2023.
//  Copyright (c) cantt39t. All rights reserved.
//  see https://github.com/cannt39t
//


import UIKit


protocol AdvertisementDisplayLogic: AnyObject {
    func displayAdvertisement(viewModel: Advertisement.Advertisement.ViewModel) async
	func displayError(error: Error) async
}

final class AdvertisementViewController: BaseController {
	
	// MARK: - Views
	
	private lazy var somethingWentWrongLabel: UILabel = {
		let label = UILabel()
		label.isHidden = true
		label.text = SomethingWentWrong.label.localized
		label.textColor = .label
		return label
	}()
	
	private lazy var repeatButton: UIButton = {
		let button = UIButton(type: .system)
		button.isHidden = true
		button.setTitle(Repeat.button.localized, for: .normal)
		button.setTitleColor(.primary, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
		button.addAction(UIAction(handler: { [weak self] _ in
			self?.getAdvertisement()
		}), for: .touchUpInside)
		return button
	}()
	
	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.showsVerticalScrollIndicator = false
		return scrollView
	}()
	
	private lazy var contentView: UIView = {
		let contentView = UIView()
		return contentView
	}()
	
	private lazy var advertisementImage: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.isUserInteractionEnabled = true
		return imageView
	}()
	
	private lazy var dataView: UIView = {
		let dataView = UIView()
		return dataView
	}()
	
	private lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textColor = .label
		label.font = .systemFont(ofSize: 23, weight: .regular)
		return label
	}()
	
	private lazy var priceLabel: UILabel = {
		let label = UILabel()
		label.textColor = .label
		label.font = .systemFont(ofSize: 23, weight: .bold)
		return label
	}()
	
	private lazy var locationLabel: UILabel = {
		let label = UILabel()
		label.textColor = .label
		label.font = .systemFont(ofSize: 19, weight: .regular)
		return label
	}()
	
	private lazy var showLocationButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle(Place.showButton.localized, for: .normal)
		button.setTitleColor(.primary, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 19, weight: .regular)
		button.addAction(UIAction(handler: { [weak self] _ in
			self?.presentLocation()
		}), for: .touchUpInside)
		return button
	}()
	
	private lazy var callButton: UIButton = {
		var filled = UIButton.Configuration.filled()
		filled.baseBackgroundColor = .secondary
		filled.title = Call.button.localized
		filled.image = .phoneFill.withTintColor(.white, renderingMode: .alwaysOriginal)
		filled.imagePlacement = .leading
		filled.imagePadding = 8
		let button = UIButton(configuration: filled, primaryAction:
								UIAction(handler: { [weak self] _ in self?.showCallAction() })
		)
		return button
	}()
	
	private lazy var chatButton: UIButton = {
		var filled = UIButton.Configuration.filled()
		filled.baseBackgroundColor = .primary
		filled.title = Message.button.localized
		filled.image = .chatFill.withTintColor(.white, renderingMode: .alwaysOriginal)
		filled.imagePlacement = .leading
		filled.imagePadding = 8
		let button = UIButton(configuration: filled, primaryAction:
								UIAction(handler: { [weak self] _ in self?.openChat() })
		)
		return button
	}()
	
	private lazy var actionStack: UIStackView = {
		let stack = UIStackView()
		stack.distribution = .fillEqually
		stack.spacing = 8
		return stack
	}()
	
	private lazy var descriptionHeader: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 19, weight: .bold)
		label.text = Decription.header.localized
		return label
	}()
	
	private lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.font = .systemFont(ofSize: 16, weight: .regular)
		label.text = Decription.header.localized
		return label
	}()
	
	private lazy var descriptionStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 8
		stack.distribution = .fillProportionally
		return stack
	}()
	
	var interactor: (AdvertisementBusinessLogic & AdvertisementDataStore)?
	var router: (NSObjectProtocol & AdvertisementRoutingLogic & AdvertisementDataPassing)?
	
	// MARK: - Object lifecycle
	
	init(id: String) {
		super.init(nibName: nil, bundle: nil)
		setup(id: id)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Setup
	
	private func setup(id: String) {
		let viewController = self
		let interactor = AdvertisementInteractor()
		let presenter = AdvertisementPresenter()
		let router = AdvertisementRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		interactor.id = id
		presenter.viewController = viewController
		router.viewController = viewController
		router.dataStore = interactor
	}
}
    
// MARK: - View lifecycle
    
extension AdvertisementViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		getAdvertisement()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let backImage: UIImage = .backArrow.withTintColor(.label, renderingMode: .alwaysOriginal)
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(popViewController))
	}
	
}

// MARK: - Requests

extension AdvertisementViewController {
	
    private func getAdvertisement() {
		state = .LOADING
		showLoader()
		let request = Advertisement.Advertisement.Request()
        interactor?.getAdvertisement(request: request)
    }
	
	private func loadImage(from URLString: String?) {
		guard let imageURLString = URLString, let imageURL = URL(string: imageURLString) else {
			advertisementImage.image = .defaultImage.withRenderingMode(.alwaysOriginal).withTintColor(.label2.withAlphaComponent(0.25))
			return
		}
		advertisementImage.sd_setImage(with: imageURL, placeholderImage: nil, options: [.highPriority])
	}
    
}

// MARK: - Displaying Logic

@MainActor
extension AdvertisementViewController: AdvertisementDisplayLogic {
	
	func displayError(error: Error) async {
		switch state {
		case .ERROR: return
		case .CONTENT, .LOADING:
			state = .ERROR
			showError()
			hideLoader()
		}
	}
	
	func displayAdvertisement(viewModel: Advertisement.Advertisement.ViewModel) async {
		switch state {
		case .ERROR:
			hideError()
		case .LOADING:
			hideError()
			hideLoader()
		case .CONTENT:
			return
		}
		
		state = .CONTENT
		let advertisement = viewModel.advertisement
		
		nameLabel.text = advertisement.title
		priceLabel.text = formatPrice(advertisement.price)
		loadImage(from: advertisement.imageURL)
		locationLabel.text = advertisement.location + ", " + advertisement.address
		descriptionLabel.text = advertisement.description
		
		setupRightNavBarButtons()
	}
	
	private func showError() {
		scrollView.isHidden = true
		somethingWentWrongLabel.isHidden = false
		repeatButton.isHidden = false
	}
	
	private func hideError() {
		scrollView.isHidden = false
		somethingWentWrongLabel.isHidden = true
		repeatButton.isHidden = true
	}
	
	private func setupRightNavBarButtons() {
		guard let isFavorite = interactor?.checkedIsFavorite() else {
			navigationController?.navigationItem.rightBarButtonItems = []
			return
		}
		let favoriteImage: UIImage = isFavorite ? .suitHeartFill.withTintColor(.heart, renderingMode: .alwaysOriginal) : .suitHeart.withTintColor(.label, renderingMode: .alwaysOriginal)
		let favoriteButton = UIBarButtonItem(image: favoriteImage, style: .plain, target: self, action: #selector(toggleFavoriteAction))
		
		let shareImage: UIImage = .share.withTintColor(.label, renderingMode: .alwaysOriginal)
		let shareButton = UIBarButtonItem(image: shareImage, style: .plain, target: self, action: #selector(presentShareAction))
		navigationItem.rightBarButtonItems = [favoriteButton, shareButton]
	}
	
}

// MARK: - Configuration

extension AdvertisementViewController {
	
	override func setupViews() {
		super.setupViews()
		
		[
			somethingWentWrongLabel,
			repeatButton,
			scrollView
		].forEach {
			view.setupView($0)
		}
		
		scrollView.setupView(contentView)
		
		[
			callButton,
			chatButton
		].forEach {
			actionStack.addArrangedSubview($0)
		}
		
		[
			descriptionHeader,
			descriptionLabel
		].forEach {
			descriptionStack.addArrangedSubview($0)
		}
		
		[
			nameLabel,
			priceLabel,
			locationLabel,
			showLocationButton,
			actionStack,
			descriptionStack
		].forEach {
			dataView.setupView($0)
		}

		[
			advertisementImage,
			dataView
		].forEach {
			contentView.setupView($0)
		}
	}
	
	override func constraintViews() {
		super.constraintViews()

		NSLayoutConstraint.activate([
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			
			contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
			
			advertisementImage.topAnchor.constraint(equalTo: contentView.topAnchor),
			advertisementImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			advertisementImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			advertisementImage.heightAnchor.constraint(equalTo: advertisementImage.widthAnchor),
			
			dataView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			dataView.topAnchor.constraint(equalTo: advertisementImage.bottomAnchor, constant: 16),
			dataView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			dataView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
			
			nameLabel.leadingAnchor.constraint(equalTo: dataView.leadingAnchor),
			nameLabel.trailingAnchor.constraint(equalTo: dataView.trailingAnchor),
			nameLabel.topAnchor.constraint(equalTo: dataView.topAnchor),
			
			priceLabel.leadingAnchor.constraint(equalTo: dataView.leadingAnchor),
			priceLabel.trailingAnchor.constraint(equalTo: dataView.trailingAnchor),
			priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
			
			locationLabel.leadingAnchor.constraint(equalTo: dataView.leadingAnchor),
			locationLabel.trailingAnchor.constraint(equalTo: dataView.trailingAnchor, constant: -32),
			locationLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
			
			showLocationButton.leadingAnchor.constraint(equalTo: dataView.leadingAnchor),
			showLocationButton.trailingAnchor.constraint(lessThanOrEqualTo: dataView.trailingAnchor),
			showLocationButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: -2),
			
			actionStack.topAnchor.constraint(equalTo: showLocationButton.bottomAnchor, constant: 16),
			actionStack.leadingAnchor.constraint(equalTo: dataView.leadingAnchor),
			actionStack.trailingAnchor.constraint(equalTo: dataView.trailingAnchor),
			actionStack.heightAnchor.constraint(equalToConstant: 48),
			
			descriptionStack.topAnchor.constraint(equalTo: actionStack.bottomAnchor, constant: 16),
			descriptionStack.leadingAnchor.constraint(equalTo: dataView.leadingAnchor),
			descriptionStack.trailingAnchor.constraint(equalTo: dataView.trailingAnchor),
			descriptionStack.bottomAnchor.constraint(equalTo: dataView.bottomAnchor, constant: -64),
			
			repeatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			repeatButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			
			somethingWentWrongLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			somethingWentWrongLabel.bottomAnchor.constraint(equalTo: repeatButton.topAnchor)
		])
	}
	
	override func configureAppearance() {
		super.configureAppearance()
		
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openPhoto))
		advertisementImage.addGestureRecognizer(tapGestureRecognizer)
	}
	
}

// MARK: - Helpers

@objc extension AdvertisementViewController {
	
	private func popViewController() {
		navigationController?.popViewController(animated: true)
	}
	
	private func showCallAction() {
		guard let phone = interactor?.advertisement?.phoneNumber else { return }
		showLoader()
		router?.makePhoneCall(phoneNumber: phone)
		hideLoader()
	}
	
	private func openPhoto() {
		let imageURL = interactor?.advertisement?.imageURL
		router?.openPhoto(imageUrl: imageURL)
	}
	
	private func openChat() {
		router?.openChat()
	}
	
	private func toggleFavoriteAction() {
		let feedbackGenerator = UINotificationFeedbackGenerator()
		feedbackGenerator.prepare()
		feedbackGenerator.notificationOccurred(.success)
		interactor?.toggleFavorite()
		setupRightNavBarButtons()
	}
	
	private func presentShareAction() {
		guard let adv = interactor?.advertisement else { return }
		let image = advertisementImage.image?.jpegData(compressionQuality: 0.8)
		
		var data: [Any] = [
			URL(string: "https://www.avito.ru/") ?? "",
			adv.title,
			adv.description,
			adv.location,
			adv.address,
		]
		
		if let image {
			data.append(image)
		}
		
		showLoader()
		router?.share(with: data)
		hideLoader()
	}
	
	private func presentLocation() {
		showLoader()
		state = .LOADING
		interactor?.getCoordinatesOfAdvertisement(completion: { [weak self] coordinates in
			self?.router?.openLocation(coordinates: coordinates)
			self?.hideLoader()
			self?.state = .CONTENT
		})
	}
	
}
