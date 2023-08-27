//
//  CatalogInteractor.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 26.08.2023.
//  Copyright (c) cantt39t. All rights reserved.
//  see https://github.com/cannt39t
//

import UIKit
import Combine

protocol CatalogBusinessLogic {
    func getAdvertisements(request: Catalog.Advertisements.Request)
	func observeCity()
}

protocol CatalogDataStore { }

final class CatalogInteractor: CatalogBusinessLogic, CatalogDataStore {
	
    var presenter: CatalogPresentationLogic?
    var worker = CatalogWorker()
	let locationManager = LocationManager.shared
	
	private var bag = Set<AnyCancellable>()
    
    func getAdvertisements(request: Catalog.Advertisements.Request) {
		Task {
			do {
				let advertisements = try await worker.requestAdvertisements()
				let response = Catalog.Advertisements.Response(error: nil, advertisements: advertisements)
				await presenter?.presentAdvertisements(response: response)
			} catch {
				let response = Catalog.Advertisements.Response(error: error, advertisements: [])
				await presenter?.presentAdvertisements(response: response)
			}
		}
    }
	
	func observeCity() {
		locationManager.requestLocation()
		locationManager.$city
			.sink { [unowned self] city in
				Task {
					await presenter?.updateCity(city: city)
				}
			}
			.store(in: &bag)
	}
}
