//
//  AdvertisementPresenter.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 27.08.2023.
//  Copyright (c) cantt39t. All rights reserved.
//  see https://github.com/cannt39t
//


import UIKit


protocol AdvertisementPresentationLogic {
    func presentAdvertisement(response: Advertisement.Advertisement.Response) async
	func presentError(response: Advertisement.Advertisement.Response) async
}

final class AdvertisementPresenter: AdvertisementPresentationLogic {
	
    weak var viewController: AdvertisementDisplayLogic?
    
    func presentAdvertisement(response: Advertisement.Advertisement.Response) async {
		guard let presentAdvertisement = response.advertisement else { fatalError("No way") }
		let viewModel = Advertisement.Advertisement.ViewModel(advertisement: presentAdvertisement)
        await viewController?.displayAdvertisement(viewModel: viewModel)
    }
	
	func presentError(response: Advertisement.Advertisement.Response) async {
		guard let error = response.error else { return }
		await viewController?.displayError(error: error)
	}
}
