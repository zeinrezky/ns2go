//
//  RegistrationViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 09/10/21.
//

import UIKit
import SafariServices
import CountryPicker

class RegistrationViewController: UIViewController {
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet var textFieldViewContainers: [UIView]!
	
	@IBOutlet weak var firstNameTextField: UITextField!
	@IBOutlet weak var lastNameTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var companyTextField: UITextField!
	@IBOutlet weak var countryTextField: UITextField!
	@IBOutlet weak var cityTextField: UITextField!
	
	@IBOutlet weak var tncLabel: UILabel!
	@IBOutlet weak var checkboxView: UIView!
	@IBOutlet weak var continueButton: UIButton!
	
	private var isTnCChecked: Bool = false {
		didSet {
			if isTnCChecked {
				checkTnC()
			} else {
				uncheckTnC()
			}
		}
	}
	
	private let service = RegisterService()
	
	private let countryPicker = CountryPicker()
	
	@IBAction func continueButtonTapped(_ sender: Any) {
		registerUser()
	}
	
	@IBAction func tncAgreeButtonTapped(_ sender: Any) {
		isTnCChecked = !isTnCChecked
	}
	
	@IBAction func tncShowButtonTapped(_ sender: Any) {
		guard let url = URL(string: BaseURL.shared.tncURL) else {
			return
		}
		
		let configuration = SFSafariViewController.Configuration()
		configuration.barCollapsingEnabled = true
		
		let safariVC = SFSafariViewController(url: url, configuration: configuration)
		safariVC.dismissButtonStyle = .close
		
		DispatchQueue.main.async { [weak self] in
			self?.present(safariVC, animated: true, completion: nil)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationBar()
		self.navigationController?.setNavigationBarHidden(false, animated: false)
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
				self?.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height + 30, right: 0)
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
	}
	
	private func setupView() {
		textFieldViewContainers.forEach( {
			$0.layer.borderWidth = 1
			$0.layer.borderColor = UIColor.darkGray.cgColor
		})
		
		uncheckTnC()
		setupTextField()
		continueButton.layer.cornerRadius = 4
		checkboxView.isUserInteractionEnabled = false
		
		let agreeString = NSAttributedString(string: "I Agree to the ", attributes: [
			NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 14.0) ?? UIFont.systemFont(ofSize: 14),
			NSAttributedString.Key.foregroundColor: UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1)
		])
		
		let tncString = NSAttributedString(string: "Terms and Conditions", attributes: [
			NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 14.0) ?? UIFont.systemFont(ofSize: 14),
			NSAttributedString.Key.foregroundColor: UIColor(red: 83.0/255.0, green: 127.0/255.0, blue: 227.0/255.0, alpha: 1),
			NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
		])
		
		let mutableAttrString = NSMutableAttributedString(attributedString: agreeString)
		mutableAttrString.append(tncString)
		tncLabel.attributedText = mutableAttrString
	}
	
	private func setupTextField() {
		firstNameTextField.addDoneButtonKeyboard()
		lastNameTextField.addDoneButtonKeyboard()
		emailTextField.addDoneButtonKeyboard()
		companyTextField.addDoneButtonKeyboard()
		countryTextField.addDoneButtonKeyboard()
		cityTextField.addDoneButtonKeyboard()
		
		countryPicker.delegate = self
		countryPicker.selectedCountryName = "United States"
		countryTextField.text = "United States"
		countryTextField.delegate = self
		countryTextField.inputView = countryPicker
		
		emailTextField.keyboardType = .emailAddress
		let comButtonItem = UIBarButtonItem(title: ".com", style: .plain, target: self, action: #selector(didTapDotCom))
		emailTextField.addDoneButtonKeyboard(additionalButton: comButtonItem)
	}
	
	@objc private func didTapDotCom() {
		emailTextField.text = (emailTextField.text ?? "") + ".com"
	}
	
	private func checkTnC() {
		let blueColor = UIColor(red: 83.0/255.0, green: 127.0/255.0, blue: 227.0/255.0, alpha: 1)
		checkboxView.layer.borderColor = blueColor.cgColor
		checkboxView.backgroundColor = blueColor
		let width = checkboxView.frame.width
		
		let insideStrokeLayer = CAShapeLayer()
		insideStrokeLayer.accessibilityLabel = "insideStroke"
		insideStrokeLayer.path = UIBezierPath(roundedRect: CGRect(x: 1, y: 1, width: width - 2, height: width - 2), cornerRadius: 0).cgPath
		insideStrokeLayer.strokeColor = UIColor.white.cgColor
		insideStrokeLayer.borderWidth = 3
		insideStrokeLayer.fillColor = UIColor.clear.cgColor
		checkboxView.layer.addSublayer(insideStrokeLayer)
	}
	
	private func uncheckTnC() {
		checkboxView.layer.borderWidth = 1
		checkboxView.layer.borderColor = UIColor.black.cgColor
		checkboxView.backgroundColor = .white
		
		checkboxView.layer.sublayers?.removeAll(where: {$0.accessibilityLabel == "insideStroke"})
	}
	
	private func registerUser() {
		
		guard let firstName = firstNameTextField.text else {
			showAlert(message: "First name cannot be empty")
			return
		}
		
		guard let lastName = lastNameTextField.text else {
			showAlert(message: "Last name cannot be empty")
			return
		}
		
		guard let email = emailTextField.text else {
			showAlert(message: "Email address cannot be empty")
			return
		}
		
		guard let companyName = companyTextField.text else {
			showAlert(message: "Company name cannot be empty")
			return
		}
		
		guard let companyCountry = countryTextField.text else {
			showAlert(message: "Company country cannot be empty")
			return
		}
		
		guard let companyCity = cityTextField.text else {
			showAlert(message: "Company city cannot be empty")
			return
		}
		
		guard isTnCChecked else {
			showAlert(message: "You need to agree our Terms and Conditions")
			return
		}
		
		guard email.isValidEmail() else {
			showAlert(message: "Email format is not valid")
			return
		}
		
		self.view.endEditing(true)
		showLoading()
		service.register(
			firstName: firstName,
			lastName: lastName,
			email: email,
			companyName: companyName,
			companyCountry: companyCountry,
			companyState: companyCity
		) { [weak self] message in
			self?.hideLoading()
			
			let willResentCode = message == "User exists."

			self?.presentOTP(email: email, willResentCode: willResentCode)
		} onFailed: { [weak self] (message) in
			self?.hideLoading()
			self?.showAlert(message: message)
		}
	}
	
	private func presentOTP(email: String, willResentCode: Bool) {
		let inputOTPVC = OTPVerificationViewController()
		inputOTPVC.modalPresentationStyle = .overCurrentContext
		inputOTPVC.email = email
		inputOTPVC.willResentCode = willResentCode
		inputOTPVC.onSuccessVerification = { [weak self] in
			self?.presentServerInformation()
		}
		
		DispatchQueue.main.async { [weak self] in
			self?.navigationController?.pushViewController(inputOTPVC, animated: true)
		}
	}

	private func presentServerInformation() {
		let serverVC = ServerInformationViewController()
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
			  let window = appDelegate.window else {
			return
		}
			
		DispatchQueue.main.async {
			window.rootViewController = serverVC
		}
	}
}

extension RegistrationViewController: UITextFieldDelegate {
	func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
		countryTextField.text = countryPicker.selectedCountryName
	}
}

extension RegistrationViewController: CountryPickerDelegate {
	func countryPicker(_ picker: CountryPicker!, didSelectCountryWithName name: String!, code: String!) {
		countryTextField.text = name
	}
}
