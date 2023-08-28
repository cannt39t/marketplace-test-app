//
//  CatalogViewController.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 26.08.2023.
//  Copyright (c) cantt39t. All rights reserved.
//  see https://github.com/cannt39t
//

import UIKit

protocol CatalogDisplayLogic: AnyObject {
	func displayAdvertisements(viewModel: Catalog.Advertisements.ViewModel) async
	func updateSearchPlaceHolder(city: String) async
	func displayError(error: Error) async
}

final class CatalogViewController: BaseCollectionController {
	
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
		button.addAction(UIAction(handler: { [weak self] _ in self?.getAdvertisements() }), for: .touchUpInside)
		return button
	}()
	
	private var dataSource: CatalogDataSource?
	private let collectionDelegete = CatalogCollectionViewDelegate()
	private var searchController: UISearchController!
	
	enum Section: Int, CaseIterable {
		case products
	}
	
	var interactor: CatalogBusinessLogic?
	var router: (NSObjectProtocol & CatalogRoutingLogic & CatalogDataPassing)?
	
	// MARK: - Object lifecycle
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		let layout = CatalogViewController.createCompositionalLayout()
		super.init(collectionViewLayout: layout)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
	// MARK: - Setup
	
	private func setup() {
		let viewController = self
		let interactor = CatalogInteractor()
		let presenter = CatalogPresenter()
		let router = CatalogRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController
		router.dataStore = interactor
	}
	
}

extension CatalogViewController {
	
	override func configureAppearance() {
		super.configureAppearance()
		
		collectionDelegete.openAdvCallBack = interactor?.openCallBack
		collectionView.dataSource = dataSource
		collectionView.delegate = collectionDelegete
		collectionView.register(AVAdvertisementCell.self)
		collectionView.backgroundColor = .background
		
		setupSearchController()
	}
	
}

// MARK: - CollectionView Layout

extension CatalogViewController {
	
	private static func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
		let layout = UICollectionViewCompositionalLayout(sectionProvider: { (index, enviroment) -> NSCollectionLayoutSection? in
			return CatalogViewController.createSectionFor(index: index, enviroment: enviroment)
		})
		return layout
	}
	
	private static func createSectionFor(index: Int, enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
		guard let section = Section(rawValue: index) else { fatalError() }
		switch section {
		case .products: return getListOfProducts()
		}
	}
	
	private static func getListOfProducts() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
											  heightDimension: .fractionalHeight(1.0))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 4)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
											   heightDimension: .absolute(300))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8)
		return section
	}

}

// MARK: - Display logic

@MainActor
extension CatalogViewController: CatalogDisplayLogic {
	
	func displayAdvertisements(viewModel: Catalog.Advertisements.ViewModel) async {
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
		
		dataSource = CatalogDataSource(advertisements: viewModel.advertisements)
		collectionDelegete.router = router
		collectionView.dataSource = dataSource
		collectionView.reloadData()
	}
	
	func updateSearchPlaceHolder(city: String) {
		guard !city.isEmpty else {
			return
		}
		searchController.searchBar.placeholder = Search.placeHolder.localized + Search.inTheCityOf.localized + city
	}
	
	func displayError(error: Error) async {
		switch state {
		case .ERROR: return
		case .CONTENT, .LOADING:
			state = .ERROR
			showError()
			hideLoader()
		}
	}
	
	private func showError() {
		somethingWentWrongLabel.isHidden = false
		repeatButton.isHidden = false
	}
	
	private func hideError() {
		somethingWentWrongLabel.isHidden = true
		repeatButton.isHidden = true
	}
	
}

// MARK: - View lifecycle

extension CatalogViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		interactor?.observeCity()
		getAdvertisements()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		collectionView.reloadData()
	}
	
}
    
// MARK: - Requests

extension CatalogViewController {
	
	func getAdvertisements() {
		state = .LOADING
		showLoader()
		let request = Catalog.Advertisements.Request()
		interactor?.getAdvertisements(request: request)
	}
	
}

// MARK: - Searching

extension CatalogViewController {
	
	private func setupSearchController() {
		searchController = UISearchController(searchResultsController: nil)
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = Search.placeHolder.localized
		navigationItem.searchController = searchController
		definesPresentationContext = true
	}
	
}

extension CatalogViewController: UISearchResultsUpdating {
	
	func updateSearchResults(for searchController: UISearchController) {
		guard let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
			  !searchText.isEmpty else {
			return
		}
	}
	
}

// MARK: - Configuration

extension CatalogViewController {
	
	override func setupViews() {
		super.setupViews()
		
		[
			somethingWentWrongLabel,
			repeatButton,
		].forEach {
			view.setupView($0)
		}
	}
	
	override func constraintViews() {
		super.constraintViews()
		
		NSLayoutConstraint.activate([
			repeatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			repeatButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			
			somethingWentWrongLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			somethingWentWrongLabel.bottomAnchor.constraint(equalTo: repeatButton.topAnchor)
		])
	}
	
}
