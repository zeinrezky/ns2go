//
//  LoginViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 10/10/21.
//

import UIKit
import KeychainAccess

class LoginViewController: UIViewController {

	@IBOutlet var textFieldContainers: [UIView]!
	
	@IBOutlet weak var scrollView: UIScrollView!
	
	@IBOutlet weak var loginIDTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	
	private let service = LoginService()
	
	private let keychain = Keychain(service: NS2GOConstant.keychainIdentifier)
	
	@IBAction func loginButtonTapped(_ sender: Any) {
		login()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupTextFieldContanier()
		loginButton.layer.cornerRadius = 4
		loginIDTextField.addDoneButtonKeyboard()
		passwordTextField.addDoneButtonKeyboard()
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
	
	private func setupNavigationBar() {
		self.setupDefaultNavigationBar()
		
		let button = UIButton()
		button.setImage(UIImage(named : "ic_setting"), for: .normal)
		button.setTitle("", for: .normal)
		button.addTarget(self, action: #selector(pushToEditServerInformation), for: .touchUpInside)
		button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
		button.widthAnchor.constraint(equalToConstant: 44).isActive = true
		button.heightAnchor.constraint(equalToConstant: 44).isActive = true
		let btBar = UIBarButtonItem(customView: button)
		self.navigationItem.rightBarButtonItem = btBar
	}
	
	private func setupTextFieldContanier() {
		textFieldContainers.forEach { [weak self] (view) in
			view.layer.borderColor = UIColor.darkGray.cgColor
			view.layer.borderWidth = 1
		}
	}
	
	@objc private func pushToEditServerInformation() {
		let lastIndex = (self.navigationController?.viewControllers.count ?? 0) - 1
		if lastIndex > 0,
		   let controllerBefore = self.navigationController?.viewControllers[lastIndex - 1],
		   controllerBefore.isKind(of: ServerInformationViewController.self) {
			DispatchQueue.main.async { [weak self] in
				self?.navigationController?.popViewController(animated: true)
			}
		} else {
			let serverVC = ServerInformationViewController()
			self.navigationController?.pushViewController(serverVC, animated: true)
		}
	}
	
	private func presentServerList(nodes: [Node]) {
		let serverListVC = ServerListViewController()
		ServiceHelper.shared.nodeAlert = nodes.first
		let navVC = UINavigationController(rootViewController: serverListVC)
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
			  let window = appDelegate.window else {
			return
		}
		
		window.rootViewController = navVC
	}
	
	private func login() {
		guard let loginID = loginIDTextField.text else {
			showAlert(message: "Login ID cannot be empty")
			return
		}
		
		guard let password = passwordTextField.text else {
			showAlert(message: "Password cannot be empty")
			return
		}
		
		showLoading()
		service.login(
			username: loginID,
			password: password,
			onComplete: { [weak self] (json, nodes) in
				self?.hideLoading()
				self?.saveCredential(loginID: loginID, password: password)
				
				ServiceHelper.shared.nodeAlertJSON = json
				self?.presentServerList(nodes: nodes)
			}, onFailed: { [weak self] (message) in
				self?.hideLoading()
				self?.showAlert(message: message)
			}
		)
	}
}
