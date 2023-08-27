//
//  AdvertisementInteractor.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 27.08.2023.
//  Copyright (c) cantt39t. All rights reserved.
//  see https://github.com/cannt39t
//


import UIKit


protocol AdvertisementBusinessLogic {
    func getAdvertisement(request: Advertisement.Advertisement.Request)
}

protocol AdvertisementDataStore {
    var id: String? { get set }
	var advertisement: AVAdvertisement? { get set }
}

final class AdvertisementInteractor: AdvertisementBusinessLogic, AdvertisementDataStore {
	
    var presenter: AdvertisementPresentationLogic?
    var worker: AdvertisementWorker = AdvertisementWorker()
	var id: String?
	var advertisement: AVAdvertisement?
    
    func getAdvertisement(request: Advertisement.Advertisement.Request) {
		Task {
			do {
				guard let id = id else {
					let response = Advertisement.Advertisement.Response(error: HttpError.wrongUrl, advertisement: nil)
					await presenter?.presentError(response: response)
					return
				}
				let advertisement = try await worker.getAdvertisement(with: id)
				let response = Advertisement.Advertisement.Response(error: nil, advertisement: advertisement)
				self.advertisement = response.advertisement
				await presenter?.presentAdvertisement(response: response)
			} catch {
				let response = Advertisement.Advertisement.Response(error: error, advertisement: nil)
				await presenter?.presentError(response: response)
			}
		}
    }
}
