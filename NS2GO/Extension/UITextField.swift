//
//  UITextField.swift
//  Binder
//
//  Created by Yosua Hoo on 23/08/19.
//  Copyright © 2019 Yosua Hoo. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
	func addDoneButtonKeyboard(additionalButton: UIBarButtonItem? = nil){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
		let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		var items = [flexible, doneButton]
		
		if let additionalButton = additionalButton {
			items.insert(additionalButton, at: 1)
		}
		
		toolbar.items = items
        self.inputAccessoryView = toolbar
    }
    
    @objc func didTapDone(){
        self.endEditing(true)
    }
}
