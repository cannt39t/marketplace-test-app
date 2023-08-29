//
//  LocationController.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 29.08.2023.
//

import UIKit
import MapKit
import CoreLocation

final class LocationController: BaseController {
	
	private lazy var mapView: MKMapView = {
		let map = MKMapView()
		return map
	}()
	
	private lazy var couldNotFoundPlaceLabel: UILabel = {
		let label = UILabel()
		label.textColor = .label
		label.isHidden = true
		label.numberOfLines = 0
		label.textAlignment = .center
		label.text = Location.error.localized
		return label
	}()
	
	private var coordinates: CLLocationCoordinate2D?
	
	init(coordinates: CLLocationCoordinate2D? = nil) {
		self.coordinates = coordinates
		super.init(nibName: nil, bundle: nil )
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func updateMapForCoordinate(coordinate: CLLocationCoordinate2D) {
		var center = coordinate;
		center.latitude -= self.mapView.region.span.latitudeDelta / 6.0;
		mapView.setCenter(center, animated: true);
	}
	
}

extension LocationController {
	
	override func setupViews() {
		super.setupViews()
		
		[
			mapView,
			couldNotFoundPlaceLabel
		].forEach {
			view.setupView($0)
		}
	}
	
	override func constraintViews() {
		super.constraintViews()
		
		NSLayoutConstraint.activate([
			mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			
			couldNotFoundPlaceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
			couldNotFoundPlaceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
			couldNotFoundPlaceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			couldNotFoundPlaceLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
	
	override func configureAppearance() {
		super.configureAppearance()
		
		navigationItem.largeTitleDisplayMode = .never
		view.backgroundColor = .background
		
		guard let coordinates = coordinates else {
			state = .ERROR
			couldNotFoundPlaceLabel.isHidden = false
			return
		}
		
		updateMapForCoordinate(coordinate: coordinates)
		let pin = MKPointAnnotation()
		pin.coordinate = coordinates
		mapView.addAnnotation(pin)
		state = .CONTENT
	}
	
}
