//
//  String.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 15/10/21.
//

import Foundation

extension String {
	func isValidEmail() -> Bool {
		let emailFormat =
		"(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
		let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
		return emailPredicate.evaluate(with: self)
	}
	
	func hexString() -> String {
		let data = Data(self.utf8)
		let hexString = data.map{ String(format:"%02x", $0) }.joined()
		return hexString
	}
}
