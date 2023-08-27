//
//  CatalogPresenter.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 26.08.2023.
//  Copyright (c) cantt39t. All rights reserved.
//  see https://github.com/cannt39t
//

import UIKit

protocol CatalogPresentationLogic {
	func presentAdvertisements(response: Catalog.Advertisements.Response) async
	func presentError(response: Catalog.Advertisements.Response) async
	func updateCity(city: String) async
}

final class CatalogPresenter: CatalogPresentationLogic {
	
    weak var viewController: CatalogDisplayLogic?
    
	func presentAdvertisements(response: Catalog.Advertisements.Response) async {
		let viewModel = Catalog.Advertisements.ViewModel(advertisements: response.advertisements)
        await viewController?.displayAdvertisements(viewModel: viewModel)
    }
	
	func presentError(response: Catalog.Advertisements.Response) async {
		
	}
	
	func updateCity(city: String) async {
		await viewController?.updateSearchPlaceHolder(city: city)
	}
}
