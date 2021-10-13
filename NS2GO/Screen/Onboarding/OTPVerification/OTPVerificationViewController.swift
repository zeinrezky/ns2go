//
//  OTPVerificationViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 10/10/21.
//

import UIKit

class OTPVerificationViewController: UIViewController {

	var onSuccessVerification: (() -> Void)?
	
	@IBOutlet weak var otpStackView: UIStackView!
	
	private var otpTextFields: [OTPTextField] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupTextFields()
    }
	
	private func presentActivationSuccess() {
		let activationSuccessVC = ActivationSuccessViewController()
		activationSuccessVC.modalPresentationStyle = .overCurrentContext
		activationSuccessVC.onSuccessVerification = { [weak self] in
			DispatchQueue.main.async { [weak self] in
				self?.dismiss(animated: false, completion: { [weak self] in
					self?.onSuccessVerification?()
				})
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
				presentActivationSuccess()
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
