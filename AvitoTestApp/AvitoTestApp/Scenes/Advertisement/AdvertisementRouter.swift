//
//  AdvertisementRouter.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 27.08.2023.
//  Copyright (c) cantt39t. All rights reserved.
//  see https://github.com/cannt39t
//

import UIKit
import CoreLocation

protocol AdvertisementRoutingLogic {
	func makePhoneCall(phoneNumber: String)
	func openPhoto(imageUrl: String?)
	func openChat()
	func share(with data: [Any])
	func openLocation(coordinates: CLLocationCoordinate2D?)
}

protocol AdvertisementDataPassing {
    var dataStore: AdvertisementDataStore? { get }
}

final class AdvertisementRouter: NSObject, AdvertisementRoutingLogic, AdvertisementDataPassing {
	
    weak var viewController: AdvertisementViewController?
    var dataStore: AdvertisementDataStore?
	
	func makePhoneCall(phoneNumber: String) {
		let clearPhone = formatPhoneNumber(phoneNumber)
		if let phoneCallURL = URL(string: "tel://\(clearPhone)") {
			let application:UIApplication = UIApplication.shared
			if (application.canOpenURL(phoneCallURL)) {
				application.open(phoneCallURL, options: [:], completionHandler: nil)
			}
		}
	}

	func openPhoto(imageUrl: String?) {
		let vc = PhotoDetailViewController(imageURL: imageUrl)
		viewController?.navigationController?.pushViewController(vc, animated: true)
	}
	
	func openChat() {
		let tabBarVC = viewController?.tabBarController as? TabBarViewController
		tabBarVC?.switchToTab(.chat)
	}
	
	func share(with data: [Any]) {
		let vc = UIActivityViewController(activityItems: data, applicationActivities: [])
		vc.popoverPresentationController?.barButtonItem = viewController?.navigationItem.rightBarButtonItem
		viewController?.present(vc, animated: true)
	}
	
	func openLocation(coordinates: CLLocationCoordinate2D?) {
		let vc = LocationController(coordinates: coordinates)
		viewController?.navigationController?.pushViewController(vc, animated: true)
	}
	
}
