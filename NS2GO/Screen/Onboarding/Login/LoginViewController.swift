//
//  LoginViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 10/10/21.
//

import UIKit
import KeychainAccess

class LoginViewController: UIViewController {
	
	@IBOutlet weak var blurView: UIView!
	
	@IBOutlet var textFieldContainers: [UIView]!
	
	@IBOutlet weak var scrollView: UIScrollView!
	
	@IBOutlet weak var loginIDTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	
	var showNavBarButton: Bool = true
	
	private let service = LoginService()
	private let keychain = Keychain(service: NS2GOConstant.keychainIdentifier)
	
	@IBAction func loginButtonTapped(_ sender: Any) {
		login()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if let loginID = ServiceHelper.shared.getCredential() {
			loginIDTextField.text = loginID
		}
		
		setupTextFieldContanier()
		loginButton.layer.cornerRadius = 4
		loginIDTextField.addDoneButtonKeyboard()
		passwordTextField.addDoneButtonKeyboard()
		loginIDTextField.delegate = self
		passwordTextField.delegate = self
		addGradientLayer()
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
	
	private func addGradientLayer() {
		let gradientLayer = CAGradientLayer()
		let blueColor = UIColor(red: 208.0/255.0, green: 228.0/255.0, blue: 253.0/255.0, alpha: 1)
		gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, blueColor.cgColor]
		gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
		gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
		gradientLayer.locations = [NSNumber(value: 0.0), NSNumber(value: 0.2), NSNumber(value: 0.5), NSNumber(value: 1)]
		gradientLayer.frame = blurView.frame
		blurView.layer.addSublayer(gradientLayer)
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
		self.navigationController?.interactivePopGestureRecognizer?.delegate = self
		
		if showNavBarButton {
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
	
	private func login() {
		guard BaseURL.shared.vpnBaseAddress != nil, BaseURL.shared.vpnBasePort != nil else {
			showAlert(message: "Please set up the server address and port")
			return
		}
		
		guard let loginID = loginIDTextField.text, !loginID.isEmpty else {
			showAlert(message: "Login ID cannot be empty")
			return
		}
		
		guard let password = passwordTextField.text, !password.isEmpty else {
			showAlert(message: "Password cannot be empty")
			return
		}
		
		showLoading()
		ServiceHelper.shared.username = loginID
		ServiceHelper.shared.password = password
		self.view.endEditing(true)
	
		ServiceHelper.shared.getNeighborhood {[weak self] (neighborhoods) in
			if neighborhoods.count > 0 {
				self?.handleNeighborhoodLogin(neighborhoods: neighborhoods)
			} else {
				ServiceHelper.shared.loginNode(ip: nil, port: nil) { [weak self] in
					self?.getSingleVersion()
				} onError: { [weak self] (message) in
					self?.hideLoading()
					self?.showAlert(message: message)
				}
			}
		} onError: { [weak self] (message) in
			self?.hideLoading()
			self?.showAlert(message: message)
		}
	}
	
	private func handleNeighborhoodLogin(neighborhoods: [Neighborhood]) {
		BaseRequest.shared.setupSession(with: neighborhoods)
		var isLoginSuccess: Bool? = nil
		var isVersionRequestSuccess: Bool? = nil
		var isStatusRequestSuccess: Bool? = nil
		
		let onAllComplete: () -> Void = {
			guard let login = isLoginSuccess,
				  let version = isVersionRequestSuccess,
				  let status = isStatusRequestSuccess else {
				return
			}
			
			let safeToLogin = login && version && status
			
			if safeToLogin {
				self.hideLoading()
				self.presentNodeListDashboard()
			}
		}
		
		doAllLogin(onComplete: { isSuccess in
			isLoginSuccess = isSuccess
			onAllComplete()
		})
		
		getAllVersion { isSuccess in
			isVersionRequestSuccess = isSuccess
			onAllComplete()
		}
		
		getAllNodeStatus { isSuccess in
			isStatusRequestSuccess = isSuccess
			onAllComplete()
			
		}
	}
	
	private func doAllLogin(onComplete: @escaping (Bool) -> Void) {
		ServiceHelper.shared.loginEachNode {
			ServiceHelper.shared.saveCredential()
			onComplete(true)
		} onError: { [weak self] (message) in
			self?.hideLoading()
			self?.showAlert(message: message)
			onComplete(false)
		}
	}
	
	private func getAllVersion(onComplete: @escaping (Bool) -> Void) {
		ServiceHelper.shared.getAllVersions {
			onComplete(true)
		} onError: { [weak self] (message) in
			self?.hideLoading()
			self?.showAlert(message: message)
			onComplete(false)
		}
	}
	
	private func getAllNodeStatus(onComplete: @escaping (Bool) -> Void) {
		ServiceHelper.shared.fetchAllStatusNode {
			onComplete(true)
		} onError: { [weak self] (message) in
			self?.hideLoading()
			self?.showAlert(message: message)
			onComplete(false)
		}
	}
	
	private func getSingleVersion() {
		ServiceHelper.shared.getVersion { [weak self] in
			self?.getSingleNodeStatus()
		} onError: {[weak self] (message) in
			self?.hideLoading()
			self?.showAlert(message: message)
		}
	}
	
	private func getSingleNodeStatus() {
		ServiceHelper.shared.fetchStatusData { [weak self] in
			self?.hideLoading()
			self?.presentNodeDashboard()
		} onError: { [weak self] message in
			self?.hideLoading()
			self?.showAlert(message: message)
		}
	}
	
	private func presentNodeListDashboard() {
		let nodeVC = ServerListViewController()
		let navVC = UINavigationController(rootViewController: nodeVC)
		
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
		
		window.rootViewController = navVC
	}
	
	private func presentNodeDashboard() {
		let nodeVC = NodeViewController()
		nodeVC.nodeAlert = ServiceHelper.shared.nodeAlert.first
		nodeVC.nodeStatus = ServiceHelper.shared.nodeStatuses.first
		nodeVC.version = ServiceHelper.shared.versions.first
		let navVC = UINavigationController(rootViewController: nodeVC)
		
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
		
		window.rootViewController = navVC
	}
}

extension LoginViewController: UIGestureRecognizerDelegate {
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		guard let nav = navigationController else {
			return false
		}
		
		return nav.viewControllers.count > 1
	}
}

extension LoginViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case loginIDTextField:
			passwordTextField.becomeFirstResponder()
		case passwordTextField:
			view.endEditing(true)
		default:
			break
		}
		
		return true
	}
}
