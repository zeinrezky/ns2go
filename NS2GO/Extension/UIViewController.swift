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
		self.navigationController?.navigationBar.tintColor = UIColor(red: 117.0/255.0, green: 117.0/255.0, blue: 117.0/255.0, alpha: 1)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController?.view.backgroundColor = .clear
		
		if (self.navigationController?.viewControllers.count ?? 0) > 1 {
			addDefaultBackButton()
		}
	}
	
	func addDefaultBackButton() {
		let button = UIButton()
		button.setImage(UIImage(named : "ic_leftArrow"), for: .normal)
		button.setTitle(nil, for: .normal)
		button.addTarget(self, action: #selector(back), for: .touchUpInside)
		button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 24)
		button.widthAnchor.constraint(equalToConstant: 44).isActive = true
		button.heightAnchor.constraint(equalToConstant: 44).isActive = true
		let leftBarButtonItem = UIBarButtonItem(customView: button)
		
		self.navigationItem.leftBarButtonItem = leftBarButtonItem
	}
	
	@objc private func back() {
		DispatchQueue.main.async {
			self.navigationController?.popViewController(animated: true)
		}
	}
	
	func showAlert(title: String = "Error", message: String? = nil, buttonPositive: String = "OK", buttonNegative: String? = nil, action: (() -> Void)? = nil) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let button = UIAlertAction(title: buttonPositive, style: .default) { (_) in
			action?()
		}
		
		alert.view.tintColor = .black
		alert.addAction(button)
		
		if let buttonNegative = buttonNegative {
			let negativeButton = UIAlertAction(title: buttonNegative, style: .cancel, handler: nil)
			alert.addAction(negativeButton)
		}
		
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
