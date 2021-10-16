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
    func addDoneButtonKeyboard(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
		let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		toolbar.items = [flexible, doneButton]
        self.inputAccessoryView = toolbar
    }
    
    @objc func didTapDone(){
        self.endEditing(true)
    }
}
