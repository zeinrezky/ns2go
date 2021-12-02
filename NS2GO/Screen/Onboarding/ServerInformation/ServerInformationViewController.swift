//
//  ServerInformationViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 10/10/21.
//

import UIKit
import NetworkExtension
import KBNumberPad

class ServerInformationViewController: UIViewController {
	
	@IBOutlet var textFieldContainers: [UIView]!
	
	@IBOutlet weak var scrollView: UIScrollView!
	
	@IBOutlet weak var ipAddressTextField: UITextField!
	@IBOutlet weak var portTextField: UITextField!
	@IBOutlet weak var saveButton: UIButton!
	
	@IBAction func saveButtonTapped(_ sender: Any) {
		
		guard let ipAddress = ipAddressTextField.text, !ipAddress.isEmpty else {
			showAlert(message: "IP Address server cannot be empty")
			return
		}
		
		guard let port = portTextField.text, !port.isEmpty else {
			showAlert(message: "Port cannot be empty")
			return
		}
		
		let ipAddressFormatted = ipAddress.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "http://", with: "")
		
		BaseURL.shared.vpnBaseAddress = ipAddressFormatted
		BaseURL.shared.vpnBasePort = port
		BaseURL.shared.saveIPServer()
		BaseRequest.shared.setupSession()
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
		
		ipAddressTextField.text = BaseURL.shared.vpnBaseAddress
		portTextField.text = BaseURL.shared.vpnBasePort
		
		ipAddressTextField.delegate = self
		portTextField.delegate = self
		
//		let numberPad = KBNumberPad()
//		numberPad.delegate = self
//		portTextField.inputView = numberPad
		portTextField.keyboardType = .asciiCapableNumberPad
		portTextField.returnKeyType = .go
		
		if UIDevice.current.userInterfaceIdiom == .phone {
			portTextField.addDoneButtonKeyboard()
		}
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
			let navVC = UINavigationController(rootViewController: loginVC)
			
			if let font = UIFont(name: "HelveticaNeue-Light", size: 18) {
				navVC.navigationBar.titleTextAttributes = [
					NSAttributedString.Key.font: font,
					NSAttributedString.Key.foregroundColor: UIColor(red: 112.0/255.0, green: 112.0/255.0, blue: 112.0/255.0, alpha: 1)
				]
			}
			
			guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
				  let window = appDelegate.window else {
				return
			}
				
			DispatchQueue.main.async {
				window.rootViewController = navVC
			}
		}		
	}
}

extension ServerInformationViewController: KBNumberPadDelegate {
	func onNumberClicked(numberPad: KBNumberPad, number: Int) {
		portTextField.text = (portTextField.text ?? "") + "\(number)"
	}
	
	func onDoneClicked(numberPad: KBNumberPad) {
		view.endEditing(true)
	}
	
	func onClearClicked(numberPad: KBNumberPad) {
		let text = portTextField.text ?? ""
		guard text.count > 0 else {
			return
		}
		portTextField.text = String(text.prefix(text.count - 1))
	}
}

extension ServerInformationViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case ipAddressTextField:
			portTextField.becomeFirstResponder()
		case portTextField:
			view.endEditing(true)
		default:
			break
		}
		
		return true
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		guard textField == portTextField,
			  UIDevice.current.userInterfaceIdiom == .pad else {
			return true
		}
		
		return string.rangeOfCharacter(from: NSCharacterSet.decimalDigits.inverted) == nil
	}
}
