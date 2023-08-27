//
//  CatalogWorker.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 26.08.2023.
//  Copyright (c) cantt39t. All rights reserved.
//  see https://github.com/cannt39t
//

import UIKit

struct AdvertisementsResponse: Codable {
	let advertisements: [AVAdvertisementPreview]
}

final class CatalogWorker {
	
	func requestAdvertisements() async throws -> [AVAdvertisementPreview] {
		guard let url = URL(string: "https://www.avito.st/s/interns-ios/main-page.json") else {
			throw HttpError.wrongUrl
		}
		
		var request = URLRequest(url: url)
		request.cachePolicy = .reloadIgnoringLocalCacheData
		
		let (data, _) = try await URLSession.shared.data(for: request)
		let decoder = JSONDecoder()
		let response = try decoder.decode(AdvertisementsResponse.self, from: data)
		
		return response.advertisements
	}
	
}
