//
//  UIViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 14/10/21.
//

import Foundation
import UIKit

extension UIViewController {
	
	static var backButtonArea: UIButton?
	
	func setupDefaultNavigationBar() {
		self.navigationController?.navigationBar.tintColor = UIColor(red: 117.0/255.0, green: 117.0/255.0, blue: 117.0/255.0, alpha: 1)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController?.view.backgroundColor = .clear
		
		if (self.navigationController?.viewControllers.count ?? 0) > 1 {
			addDefaultBackButton()
		} else {
			UIViewController.backButtonArea?.removeFromSuperview()
			UIViewController.backButtonArea = nil
		}
	}
	
	func addDefaultBackButton() {
		let button = UIButton()
		button.setImage(UIImage(named : "ic_leftArrow"), for: .normal)
		button.setTitle(nil, for: .normal)
		button.addTarget(self, action: #selector(back), for: .touchUpInside)
		button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 40)
		button.widthAnchor.constraint(equalToConstant: 60).isActive = true
		button.heightAnchor.constraint(equalToConstant: 44).isActive = true
		let leftBarButtonItem = UIBarButtonItem(customView: button)
		
		self.navigationItem.leftBarButtonItem = leftBarButtonItem
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			let backArea = UIButton()
			let safeAreaTop = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
			backArea.backgroundColor = .clear
			backArea.widthAnchor.constraint(equalToConstant: 100).isActive = true
			backArea.heightAnchor.constraint(equalToConstant: 60 + safeAreaTop).isActive = true
			backArea.addTarget(self, action: #selector(self.back), for: .touchUpInside)
			backArea.frame = CGRect(x: 0, y: 0, width: 100, height: 60 + safeAreaTop)
			UIViewController.backButtonArea = backArea
			self.navigationController?.view.addSubview(backArea)
		}
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
