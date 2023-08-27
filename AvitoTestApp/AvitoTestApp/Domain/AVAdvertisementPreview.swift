//
//  AVAdvertisementPreview.swift.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 26.08.2023.
//

import Foundation

struct AVAdvertisementPreview: Codable {
	let id, title, price, location: String
	let imageURL: String
	let createdDate: String
	
	enum CodingKeys: String, CodingKey {
		case id, title, price, location
		case imageURL = "image_url"
		case createdDate = "created_date"
	}
}
