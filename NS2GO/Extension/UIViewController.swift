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
	
	func showAlert(title: String = "Error", message: String? = nil, button: String = "OK", action: (() -> Void)? = nil) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let button = UIAlertAction(title: button, style: .default) { (_) in
			action?()
		}
		
		alert.addAction(button)
		
		DispatchQueue.main.async { [weak self] in
			self?.present(alert, animated: true, completion: nil)
		}
	}
	
	func showLoading() {
		LoadingIndicator.shared.frame = self.view.frame
		
		DispatchQueue.main.async { [weak self] in
			self?.view.addSubview(LoadingIndicator.shared)
		}
	}
	
	func hideLoading() {
		DispatchQueue.main.async { [weak self] in
			LoadingIndicator.shared.removeFromSuperview()
		}
	}
	
}
