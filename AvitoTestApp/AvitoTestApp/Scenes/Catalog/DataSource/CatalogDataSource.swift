//
//  CatalogDataSource.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 26.08.2023.
//

import UIKit

final class CatalogDataSource: NSObject, UICollectionViewDataSource {

	var advertisements: [AVAdvertisementPreview]
	
	init(advertisements: [AVAdvertisementPreview]) {
		self.advertisements = advertisements
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		CatalogViewController.Section.allCases.count
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		advertisements.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let index = indexPath.item
		let cell = collectionView.getReuseCell(AVAdvertisementCell.self, indexPath: indexPath)
		cell.configure(with: advertisements[index])
		return cell
	}
}
