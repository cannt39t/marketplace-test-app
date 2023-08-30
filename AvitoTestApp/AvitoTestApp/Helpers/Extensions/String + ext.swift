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

func formatPrice(_ input: String) -> String {
	let formatter = NumberFormatter()
	formatter.numberStyle = .decimal
	formatter.groupingSeparator = " "
	
	let components = input.components(separatedBy: " ")
	if components.count == 2, let amount = formatter.number(from: components[0]) {
		let formattedAmount = formatter.string(from: amount) ?? ""
		return "\(formattedAmount) \(components[1])"
	}
	
	return input
}

