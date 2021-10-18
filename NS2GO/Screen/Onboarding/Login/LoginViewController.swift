//
//  LoginViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 10/10/21.
//

import UIKit
import LocalAuthentication
import KeychainAccess

class LoginViewController: UIViewController {

	@IBOutlet var textFieldContainers: [UIView]!
	
	@IBOutlet weak var scrollView: UIScrollView!
	
	@IBOutlet weak var loginIDTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	
	private let service = LoginService()
	private var biometricContext = LAContext()
	
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
		
		checkAuthorizationToUseFaceID()
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
		serverListVC.nodeAlert = nodes.first
		let navVC = UINavigationController(rootViewController: serverListVC)
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
			  let window = appDelegate.window else {
			return
		}
		
		window.rootViewController = navVC
	}
	
	private func checkAuthorizationToUseFaceID() {
		
		var error: NSError?
		let permissions = biometricContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
		
		guard error == nil,
			  isUserLoggedIn() else {
			print(error?.localizedDescription ?? "")
			return
		}
		
		if permissions {
			doFaceIDBiometric()
		}
	}
	
	private func doFaceIDBiometric() {
		let reason = "Log in with Face ID"
		biometricContext.evaluatePolicy(
			.deviceOwnerAuthenticationWithBiometrics,
			localizedReason: reason
		) { [weak self] success, error in
			guard error == nil else {
				print(error?.localizedDescription ?? "")
				return
			}
			
			let credentials = self?.loadCredential()
			let loginID = credentials?.0
			let password = credentials?.1
			
			DispatchQueue.main.async { [weak self] in
				self?.loginIDTextField.text = loginID
				self?.passwordTextField.text = password
				self?.login()
			}
		}
	}
	
	private func loadCredential() -> (String?, String?){
		var loginID: String?
		var password: String?
		
		do {
			loginID = try keychain.getString(NS2GOConstant.KeyLoginID)
			password = try keychain.getString(NS2GOConstant.KeyPassword)
		} catch {
			print(error.localizedDescription)
		}
		
		return (loginID, password)
	}
	
	private func saveCredential(loginID: String, password: String) {
		do {
			try keychain.set(loginID, key: NS2GOConstant.KeyLoginID)
			try keychain.set(password, key: NS2GOConstant.KeyPassword)
			try keychain.set("YES", key: NS2GOConstant.KeyUserLoggedIn)
		} catch {
			print(error.localizedDescription)
		}
	}
	
	private func isUserLoggedIn() -> Bool {
		var isUserLoggedIn = false
		
		do {
			let loggedIn = try keychain.getString(NS2GOConstant.KeyUserLoggedIn)
			isUserLoggedIn = loggedIn == "YES"
		} catch {
			print(error.localizedDescription)
		}
		
		return isUserLoggedIn
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
			onComplete: { [weak self] (nodes) in
				self?.hideLoading()
				self?.saveCredential(loginID: loginID, password: password)
				self?.presentServerList(nodes: nodes)
			}, onFailed: { [weak self] (message) in
				self?.hideLoading()
				self?.showAlert(message: message)
			}
		)
	}
}
