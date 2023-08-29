//
//  AdvertisementInteractor.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 27.08.2023.
//  Copyright (c) cantt39t. All rights reserved.
//  see https://github.com/cannt39t
//


import UIKit
import CoreLocation

protocol AdvertisementBusinessLogic {
    func getAdvertisement(request: Advertisement.Advertisement.Request)
	func toggleFavorite()
	func checkedIsFavorite() -> Bool?
	func getCoordinatesOfAdvertisement(completion: @escaping (CLLocationCoordinate2D?) -> Void)
}

protocol AdvertisementDataStore {
    var id: String? { get set }
	var advertisement: AVAdvertisement? { get set }
}

final class AdvertisementInteractor: AdvertisementBusinessLogic, AdvertisementDataStore {
	
    var presenter: AdvertisementPresentationLogic?
    var worker: AdvertisementWorker = AdvertisementWorker()
	
	let coreDataManager = CoreDataMamanager.shared
	let locationManager = LocationManager.shared
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
	
	func toggleFavorite() {
		guard let advertisement = advertisement else { return }
		if let adv = coreDataManager.fetchAdv(with: advertisement.id) {
			coreDataManager.updataAdv(with: advertisement.id, newIsFavorite: !adv.isFavorite, newIsViewed: adv.isViewed)
		} else {
			coreDataManager.createAdvInfo(advertisement.id, isViewed: false, isFavorite: true)
		}
	}
	
	func checkedIsFavorite() -> Bool? {
		guard let advertisement = advertisement else { return nil }
		if let adv = CoreDataMamanager.shared.fetchAdv(with: advertisement.id) {
			return adv.isFavorite
		} else {
			return false
		}
	}
	
	func getCoordinatesOfAdvertisement(completion: @escaping (CLLocationCoordinate2D?) -> Void) {
		guard let advertisement = advertisement else {
			completion(nil)
			return
		}
		
		locationManager.getCoordinateFrom(address: "\(advertisement.location), \(advertisement.address)") { coordinate, error in
			if error != nil {
				completion(nil)
			} else if let coordinate = coordinate {
				completion(coordinate)
			} else {
				completion(nil)
			}
		}
	}
	
}
