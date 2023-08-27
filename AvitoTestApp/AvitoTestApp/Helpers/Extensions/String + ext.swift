//
//  String + ext.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 27.08.2023.
//

import Foundation

func formatPhoneNumber(_ phoneNumber: String) -> String {
	let digits = phoneNumber.filter { $0.isNumber }
	
	if digits.first == "1" {
		return "+" + String(digits.dropFirst())
	} else {
		return "+" + digits
	}
}
