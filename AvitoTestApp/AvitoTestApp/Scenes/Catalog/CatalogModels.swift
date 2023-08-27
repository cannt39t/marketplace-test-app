//
//  CatalogModels.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 26.08.2023.
//  Copyright (c) cantt39t. All rights reserved.
//  see https://github.com/cannt39t
//

import UIKit

enum Catalog {
    
    enum Advertisements {
        
        struct Request { }
		
        struct Response {
			let error: Error?
			let advertisements: [AVAdvertisementPreview]
		}
		
        struct ViewModel {
			let advertisements: [AVAdvertisementPreview]
		}
		
    }
	
}
