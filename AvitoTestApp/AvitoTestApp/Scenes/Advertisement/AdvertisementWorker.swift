//
//  AdvertisementWorker.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 27.08.2023.
//  Copyright (c) cantt39t. All rights reserved.
//  see https://github.com/cannt39t
//

import Foundation

final class AdvertisementWorker {
	
	func getAdvertisement(with id: String) async throws -> AVAdvertisement {
		guard let url = URL(string: "https://www.avito.st/s/interns-ios/details/\(id).json") else {
			throw HttpError.wrongUrl
		}
		
		var request = URLRequest(url: url)
		request.cachePolicy = .reloadIgnoringLocalCacheData
		
		let (data, _) = try await URLSession.shared.data(for: request)
		let decoder = JSONDecoder()
		let response = try decoder.decode(AVAdvertisement.self, from: data)
		
		return response
	}
	
}
