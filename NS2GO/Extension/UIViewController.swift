//
//  UIViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 14/10/21.
//

import Foundation
import UIKit

extension UIViewController {
	
	func setupDefaultNavigationBar() {
		self.navigationItem.backButtonTitle = " "
		self.navigationController?.navigationBar.tintColor = UIColor(red: 117.0/255.0, green: 117.0/255.0, blue: 117.0/255.0, alpha: 1)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController?.view.backgroundColor = .clear
	}
	
}
