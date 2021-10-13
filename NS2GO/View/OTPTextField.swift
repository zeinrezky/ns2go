//
//  OTPTextField.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 13/10/21.
//

import Foundation
import UIKit

protocol TextFieldDeleteDelegate {
	func didDelete(_ textField: UITextField)
}

class OTPTextField: UITextField {
	var deleteDelegate: TextFieldDeleteDelegate?
	
	override func deleteBackward() {
		super.deleteBackward()
		deleteDelegate?.didDelete(self)
	}
}
