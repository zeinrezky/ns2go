//
//  ServerInformationViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 10/10/21.
//

import UIKit
import NetworkExtension

class ServerInformationViewController: UIViewController {
	
	@IBOutlet var textFieldContainers: [UIView]!
	
	@IBOutlet weak var scrollView: UIScrollView!
	
	@IBOutlet weak var ipAddressTextField: UITextField!
	@IBOutlet weak var portTextField: UITextField!
	@IBOutlet weak var saveButton: UIButton!
	
	@IBAction func saveButtonTapped(_ sender: Any) {
		guard let ipAddress = ipAddressTextField.text,
			  let port = portTextField.text else {
			return
		}
		
		BaseURL.shared.vpnBaseAddress = ipAddress
		BaseURL.shared.vpnBasePort = port
		BaseURL.shared.saveIPServer()
		redirectToLogin()
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationBar()
		NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	@objc func showKeyboard(_ notification: NSNotification) {
		if let userInfo = notification.userInfo,
			let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			DispatchQueue.main.async { [weak self] in
				self?.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
			}
		}
	}
	
	@objc func hideKeyboard(){
		DispatchQueue.main.async { [weak self] in
			self?.scrollView.contentInset = UIEdgeInsets.zero
		}
	}
	
	private func setupView() {
		saveButton.layer.cornerRadius = 4
		setupTextFieldContanier()
		ipAddressTextField.addDoneButtonKeyboard()
		portTextField.addDoneButtonKeyboard()
		
		ipAddressTextField.text = BaseURL.shared.vpnBaseAddress
		portTextField.text = BaseURL.shared.vpnBasePort
	}
	
	private func setupNavigationBar() {
		self.setupDefaultNavigationBar()
	}
	
	private func setupTextFieldContanier() {
		textFieldContainers.forEach { (view) in
			view.layer.borderColor = UIColor.darkGray.cgColor
			view.layer.borderWidth = 1
		}
	}
	
	private func redirectToLogin() {
		
		let lastIndex = (self.navigationController?.viewControllers.count ?? 0) - 1
		if lastIndex > 0,
		   let controllerBefore = self.navigationController?.viewControllers[lastIndex - 1],
		   controllerBefore.isKind(of: LoginViewController.self) {
			DispatchQueue.main.async { [weak self] in
				self?.navigationController?.popViewController(animated: true)
			}
		} else {
			let loginVC = LoginViewController()
			DispatchQueue.main.async { [weak self] in
				self?.navigationController?.pushViewController(loginVC, animated: true)
			}
		}		
	}
}
