//
//  DateFormatter + ext.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 27.08.2023.
//

import Foundation


public extension DateFormatter {
	
	static let MMMMd: DateFormatter = {
		let df = DateFormatter()
		df.dateFormat = "MMMM d"
		return df
	}()
	
	static let yyyyMMddNotHyphenated: DateFormatter = {
		let df = DateFormatter()
		df.dateFormat = "yyyy-MM-dd"
		return df
	}()
	
}
