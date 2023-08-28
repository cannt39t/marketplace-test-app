//
//  CatalogCollectionViewDelegate.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 26.08.2023.
//

import UIKit

final class CatalogCollectionViewDelegate: NSObject, UICollectionViewDelegate {
	
	weak var router: (NSObjectProtocol & CatalogRoutingLogic & CatalogDataPassing)?
	var openAdvCallBack: ((String) -> Void)? = { _ in }
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let cell = collectionView.cellForItem(at: indexPath) as? AVAdvertisementCell, let advertisement = cell.advertisement else { fatalError() }
		router?.navigateToAdvertisementViewController(destination: AdvertisementViewController(id: advertisement.id))
		openAdvCallBack?(advertisement.id)
	}
	
}
