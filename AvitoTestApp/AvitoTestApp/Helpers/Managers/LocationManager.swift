//
//  LocationManager.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 26.08.2023.
//

import Foundation
import CoreLocation

import Foundation
import CoreLocation

final class LocationManager: NSObject, ObservableObject {
	
	private let locationManager = CLLocationManager()
	static let shared = LocationManager()
	@Published var city: String = ""

	private override init() {
		super.init()
		
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.delegate = self
		requestLocation()
	}
	
	func requestLocation() {
		locationManager.requestWhenInUseAuthorization()
		if locationManager.authorizationStatus == .notDetermined {
			locationManager.requestLocation()
		}
	}
	
	func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
		CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
	}
	
}

extension LocationManager: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		let geocoder = CLGeocoder()
		geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
			if let placemark = placemarks?.first {
				DispatchQueue.main.async {
					self?.city = placemark.locality ?? ""
				}
			}
		}
		
		locationManager.stopUpdatingLocation()
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .authorizedWhenInUse, .authorizedAlways:
			locationManager.startUpdatingLocation()
		default:
			break
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Location update failed with error: \(error.localizedDescription)")
	}
}
