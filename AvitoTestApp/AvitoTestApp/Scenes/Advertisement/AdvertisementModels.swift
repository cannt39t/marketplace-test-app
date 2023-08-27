//
//  AdvertisementModels.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 27.08.2023.
//  Copyright (c) cantt39t. All rights reserved.
//  see https://github.com/cannt39t
//


import UIKit


enum Advertisement {
    
    enum Advertisement {
        
        struct Request { }
		
		struct Response {
			let error: Error?
			let advertisement: AVAdvertisement?
		}
		
		struct ViewModel {
			let advertisement: AVAdvertisement
		}
		
    }
	
}
