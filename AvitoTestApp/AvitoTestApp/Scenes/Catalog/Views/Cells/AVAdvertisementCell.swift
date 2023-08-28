//
//  AVAdvertisementCell.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 26.08.2023.
//

import UIKit
import SDWebImage

final class AVAdvertisementCell: BaseCollectionViewCell {
	
	var advertisement: AVAdvertisementPreview?
	
	private lazy var advertisementImage: UIImageView = {
		let imageView = UIImageView()
		imageView.layer.cornerRadius = 6
		imageView.layer.masksToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14, weight: .medium)
		label.textColor = .label
		label.numberOfLines = 2
		return label
	}()
	
	private lazy var priceLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 15, weight: .bold)
		label.textColor = .label
		label.numberOfLines = 1
		return label
	}()
	
	private lazy var placeLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 12, weight: .regular)
		label.textColor = .label2
		label.numberOfLines = 1
		return label
	}()
	
	private lazy var publishedAtLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 12, weight: .regular)
		label.textColor = .label2
		label.numberOfLines = 1
		return label
	}()
	
	private lazy var favoriteButton: UIButton = {
		let button = UIButton()
		button.setImage(.suitHeart.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
		button.setImage(.suitHeartFill.withTintColor(.heart, renderingMode: .alwaysOriginal), for: .selected)
		return button
	}()
	
	private lazy var optionButton: UIButton = {
		let button = UIButton()
		button.setImage(.ellipsis.withTintColor(.label2, renderingMode: .alwaysOriginal), for: .normal)
		return button
	}()
	
	private lazy var actionStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 4
		return stack
	}()
	
	private lazy var isViewedLabel: UILabel = {
		let label = UILabel()
		label.text = Viewed.advCell.localized
		label.backgroundColor = .black.withAlphaComponent(0.2)
		label.textAlignment = .center
		label.textColor = .background
		label.font = .systemFont(ofSize: 11, weight: .regular)
		label.layer.cornerRadius = 4
		label.layer.masksToBounds = true
		return label
	}()
	
	func configure(with advertisement: AVAdvertisementPreview) {
		self.advertisement = advertisement
		
		nameLabel.text = advertisement.title
		placeLabel.text = advertisement.location
		priceLabel.text = advertisement.price
		loadImage(from: advertisement.imageURL)
		
		favoriteButton.isSelected = checkedIsFavorite(id: advertisement.id)
		isViewedLabel.isHidden = !checkedIsViewed(id: advertisement.id)
		
		publishedAtLabel.text = convertDateString(advertisement.createdDate)
	}
	
}

extension AVAdvertisementCell {
	
	override func setupViews() {
		super.setupViews()
		
		[
			favoriteButton,
			optionButton
		].forEach {
			actionStack.addArrangedSubview($0)
		}
		
		[
			advertisementImage,
			actionStack,
			nameLabel,
			priceLabel,
			placeLabel,
			publishedAtLabel,
			isViewedLabel
		].forEach {
			setupView($0)
		}
	}
	
	override func constraintViews() {
		super.constraintViews()
		
		NSLayoutConstraint.activate([
			favoriteButton.widthAnchor.constraint(equalToConstant: 32),
			favoriteButton.heightAnchor.constraint(equalToConstant: 32),
			
			optionButton.widthAnchor.constraint(equalToConstant: 32),
			optionButton.heightAnchor.constraint(equalToConstant: 32),
			
			advertisementImage.leadingAnchor.constraint(equalTo: leadingAnchor),
			advertisementImage.topAnchor.constraint(equalTo: topAnchor),
			advertisementImage.trailingAnchor.constraint(equalTo: trailingAnchor),
			advertisementImage.heightAnchor.constraint(equalTo: advertisementImage.widthAnchor),
			
			actionStack.trailingAnchor.constraint(equalTo: trailingAnchor),
			actionStack.topAnchor.constraint(equalTo: advertisementImage.bottomAnchor, constant: 4),
			
			nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			nameLabel.trailingAnchor.constraint(equalTo: actionStack.leadingAnchor, constant: -16),
			nameLabel.topAnchor.constraint(equalTo: advertisementImage.bottomAnchor, constant: 8),
			
			priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
			priceLabel.trailingAnchor.constraint(equalTo: actionStack.leadingAnchor, constant: -16),
			
			placeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			placeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
			placeLabel.trailingAnchor.constraint(equalTo: actionStack.leadingAnchor, constant: -16),
			
			publishedAtLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			publishedAtLabel.topAnchor.constraint(equalTo: placeLabel.bottomAnchor, constant: 4),
			publishedAtLabel.trailingAnchor.constraint(equalTo: actionStack.leadingAnchor, constant: -16),
			
			isViewedLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
			isViewedLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
			isViewedLabel.widthAnchor.constraint(equalToConstant: 90),
			isViewedLabel.heightAnchor.constraint(equalToConstant: 17),
		])
	}
	
	override func configureAppearance() {
		super.configureAppearance()
		
		layer.cornerRadius = 6
		layer.masksToBounds = true
		favoriteButton.startAnimatingPressActions()
		favoriteButton.addTarget(self, action: #selector(tappedFavoriteButton), for: .touchUpInside)
	}
	
}

@objc extension AVAdvertisementCell {
	
	func tappedFavoriteButton() {
		favoriteButton.isSelected.toggle()
		guard let advertisement = advertisement else { return }
		if let adv = CoreDataMamanager.shared.fetchAdv(with: advertisement.id) {
			CoreDataMamanager.shared.updataAdv(with: advertisement.id, newIsFavorite: !adv.isFavorite, newIsViewed: adv.isViewed)
		} else {
			CoreDataMamanager.shared.createAdvInfo(advertisement.id, isViewed: false, isFavorite: true)
		}
	}
	
}

extension AVAdvertisementCell {
	
	private func loadImage(from URLString: String?) {
		guard let imageURLString = URLString, let imageURL = URL(string: imageURLString) else {
			advertisementImage.image = .defaultImage.withRenderingMode(.alwaysOriginal).withTintColor(.label2.withAlphaComponent(0.25))
			return
		}
		advertisementImage.sd_setImage(with: imageURL, placeholderImage: nil, options: [.highPriority])
	}
	
	private func convertDateString(_ dateString: String) -> String {
		if let date = DateFormatter.yyyyMMddNotHyphenated.date(from: dateString) {
			return DateFormatter.MMMMd.string(from: date).capitalized
		}
		
		return dateString
	}
	
	// Немного выйти за рамки архитектуры, чтобы не тянуть кложуры с интерактора
	
	private func checkedIsViewed(id: String) -> Bool {
		if let adv = CoreDataMamanager.shared.fetchAdv(with: id) {
			return adv.isViewed
		} else {
			return false
		}
	}
	
	private func checkedIsFavorite(id: String) -> Bool {
		if let adv = CoreDataMamanager.shared.fetchAdv(with: id) {
			return adv.isFavorite
		} else {
			return false
		}
	}
	
}
