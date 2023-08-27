//
//  CatalogCollectionViewDelegate.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 26.08.2023.
//

import UIKit

final class CatalogCollectionViewDelegate: NSObject, UICollectionViewDelegate {
	
	weak var router: (NSObjectProtocol & CatalogRoutingLogic & CatalogDataPassing)?
	
	func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
		guard let cell = collectionView.cellForItem(at: indexPath) else { return }
		UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 5, options: [],animations: {
			cell.transform = CGAffineTransformMakeScale(0.95, 0.95)
		}, completion: { finished in
			
		})
	}
	
	func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
		guard let cell = collectionView.cellForItem(at: indexPath) else { return }
		UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 5, options: .curveEaseIn,animations: {
			cell.transform = CGAffineTransformMakeScale(1, 1)
		},completion: { finished in
			
		})
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let cell = collectionView.cellForItem(at: indexPath) as? AVAdvertisementCell, let advertisement = cell.advertisement else { fatalError() }
		router?.navigateToAdvertisementViewController(destination: AdvertisementViewController(id: advertisement.id))
		if let adv = CoreDataMamanager.shared.fetchAdv(with: advertisement.id) {
			if !adv.isViewed {
				CoreDataMamanager.shared.updataAdv(with: advertisement.id, newIsFavorite: adv.isFavorite, newIsViewed: true)
			}
		} else {
			CoreDataMamanager.shared.createAdvInfo(advertisement.id, isViewed: true, isFavorite: false)
		}
	}
}
