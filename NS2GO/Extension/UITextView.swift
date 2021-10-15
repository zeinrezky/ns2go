//
//  UITextView.swift
//  Binder
//
//  Created by Yosua Hoo on 29/11/19.
//  Copyright © 2019 Yosua Hoo. All rights reserved.
//

import Foundation
import UIKit

extension UITextView{
    func addDoneButtonKeyboard(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
		toolbar.items = [.flexibleSpace(), doneButton]
        self.inputAccessoryView = toolbar
    }
    
    @objc func didTapDone(){
        self.endEditing(true)
    }
}
