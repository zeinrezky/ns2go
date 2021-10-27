//
//  OTPVerificationViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 10/10/21.
//

import UIKit

class OTPVerificationViewController: UIViewController {

	var onSuccessVerification: (() -> Void)?
	var email: String?
	var willResentCode: Bool = false
	
	@IBOutlet weak var otpStackView: UIStackView!
	@IBOutlet weak var continueButton: UIButton!
	
	private var otpTextFields: [OTPTextField] = []
	private let request = RegisterService()
	private var resentCodeTimer: Timer? = nil
	
	@IBAction func continueButtonTapped(_ sender: Any) {
		validateUser()
	}
	
	@IBAction func resentCodeTapped(_ sender: Any) {
		resentCode()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupTextFields()
		continueButton.layer.cornerRadius = 4
		
		if willResentCode {
			resentCode()
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupTimer()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		resentCodeTimer?.invalidate()
	}
	
	private func presentActivationSuccess() {
		let activationSuccessVC = ActivationSuccessViewController()
		activationSuccessVC.modalPresentationStyle = .overCurrentContext
		activationSuccessVC.onSuccessVerification = { [weak self] in
			DispatchQueue.main.async { [weak self] in
				self?.navigationController?.popViewController(animated: true)
				self?.onSuccessVerification?()
			}
		}
		
		DispatchQueue.main.async { [weak self] in
			self?.present(activationSuccessVC, animated: true, completion: nil)
		}
	}
	
	private func setupTextFields() {
		otpStackView.spacing = 8
		
		for i in 0...5 {
			let otpTextField = createOTPTextField(tag: i)
			otpStackView.addArrangedSubview(otpTextField)
		}
		
		otpTextFields.first?.becomeFirstResponder()
	}
	
	private func createOTPTextField(tag: Int) -> UIView {
		let textField = OTPTextField()
		textField.tag = tag
		textField.textAlignment = .center
		textField.borderStyle = .none
		textField.font = UIFont.systemFont(ofSize: 40, weight: .bold)
		textField.delegate = self
		textField.deleteDelegate = self
		textField.keyboardType = .asciiCapableNumberPad
		textField.translatesAutoresizingMaskIntoConstraints = false
		otpTextFields.append(textField)
		
		let bg = UIView()
		bg.layer.cornerRadius = 8
		bg.backgroundColor = UIColor(red: 226.0/255.0, green: 235.0/255.0, blue: 237.0/255.0, alpha: 1)
		bg.addSubview(textField)
		
		let leadingConstraint = NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: bg, attribute: .leading, multiplier: 1, constant: 4)
		let trailingConstraint = NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: bg, attribute: .trailing, multiplier: 1, constant: -4)
		let topConstraint = NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: bg, attribute: .top, multiplier: 1, constant: 12)
		let bottomConstraint = NSLayoutConstraint(item: textField, attribute: .bottom, relatedBy: .equal, toItem: bg, attribute: .bottom, multiplier: 1, constant: -12)
		
		NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
		
		return bg
	}
	
	private func getOTPTextFieldWith(tag: Int) -> OTPTextField? {
		return otpTextFields.first(where: {$0.tag == tag})
	}
	
	private func getOTPCodeFromTextFields() -> String {
		var code: String = ""
		for textfield in otpTextFields {
			code.append(textfield.text ?? "")
		}
		
		return code
	}
	
	private func validateUser() {
		let code = getOTPCodeFromTextFields()
		
		guard let email = email,
			  !code.isEmpty,
			  code.count == 6 else {
			showAlert(message: "Please check your email to get the 6 number code")
			return
		}
		
		self.showLoading()
		request.validate(email: email, code: code) { [weak self] in
			self?.hideLoading()
			UserDefaults.standard.setValue(true, forKey: NS2GOConstant.KeyUserRegistered)
			self?.presentActivationSuccess()
		} onFailed: { [weak self] (message) in
			self?.hideLoading()
			self?.showAlert(message: message)
		}
	}
	
	private func resentCode() {
		guard let email = email else {
			showAlert(message: "There is something wrong")
			return
		}
		
		request.resendCode(
			email: email,
			onComplete: { [weak self] in
				if !(self?.willResentCode ?? false) {
					self?.showAlert(title: "Code resent", message: "Please check your email")
				}
				self?.willResentCode = false
			}, onFailed: { [weak self] (message) in
				self?.showAlert(message: message)
			}
		)
	}
	
	private func setupTimer() {
		let minutes: Double = 10
		let timeInterval: Double = minutes * 60
		resentCodeTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { [weak self] (_) in
			self?.willResentCode = true
			self?.resentCode()
		})
	}

}

extension OTPVerificationViewController : UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		guard var currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
		
		if currentText.count > 1 {
			if let last = currentText.last{
				currentText = String(last)
			}
		}
		
		if currentText.isEmpty {
			return true
		}
		
		for otpTextField in otpTextFields {
			if otpTextField != textField || (otpTextField.text ?? "").isEmpty {
				continue
			}
			
			if otpTextField.tag == (otpTextFields.count - 1) {
				return false
			}
			
			guard let nextTextField = getOTPTextFieldWith(tag: otpTextField.tag + 1) else {
				continue
			}
			
			nextTextField.text = currentText
			nextTextField.becomeFirstResponder()
			
			if nextTextField == otpTextFields.last {
				validateUser()
			}
			
			return false
		}
		
		return true
	}
}

extension OTPVerificationViewController : TextFieldDeleteDelegate {
	func didDelete(_ textField: UITextField) {
		for otpTextField in otpTextFields {
			if otpTextField != textField {
				continue
			}
			
			guard let beforeTextField = getOTPTextFieldWith(tag: otpTextField.tag - 1) else {
				continue
			}
			
			textField.text = ""
			beforeTextField.becomeFirstResponder()
			break
		}
	}
}
