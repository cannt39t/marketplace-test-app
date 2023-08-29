//
//  CatalogRouter.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 26.08.2023.
//  Copyright (c) cantt39t. All rights reserved.
//  see https://github.com/cannt39t
//

import UIKit

protocol CatalogRoutingLogic {
	func navigateToAdvertisementViewController(destination: AdvertisementViewController)
}

protocol CatalogDataPassing {
    var dataStore: CatalogDataStore? { get }
}

final class CatalogRouter: NSObject, CatalogRoutingLogic, CatalogDataPassing {
	
    weak var viewController: CatalogViewController?
    var dataStore: CatalogDataStore?
    
	func navigateToAdvertisementViewController(destination: AdvertisementViewController) {
		viewController?.navigationController?.pushViewController(destination, animated: true)
	}

}
