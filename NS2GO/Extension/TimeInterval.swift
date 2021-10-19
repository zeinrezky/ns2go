//
//  TimeInterval.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 19/10/21.
//

import Foundation

extension TimeInterval {
	func toString() -> String {
		let time = Int(self)
		
		let hour = time / 3600
		if hour > 0 {
			return "\(hour) hour\(hour > 1 ? "s" : "")"
		}
		
		let minute = time / 60
		if minute > 0 {
			return "\(minute) minute\(minute > 1 ? "s" : "")"
		}
		
		let second = time
		return "\(second) second\(second > 1 ? "s" : "")"
	}
}
