//
//  RegistrationTableViewCell.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 09/10/21.
//

import UIKit
import CountryPicker

class RegistrationTableViewCell: UITableViewCell {
	
	static let identifier: String = "RegistrationTableViewCell"
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var textFieldContainer: UIView!
	@IBOutlet weak var inputTextField: UITextField!
	
	private var cellType: CellType = .firstName
	
	private let countryPicker = CountryPicker()

    override func awakeFromNib() {
        super.awakeFromNib()
		setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func getValue() -> (CellType, String?){
		let text = (inputTextField.text ?? "").isEmpty ? nil : inputTextField.text
		return (cellType, text)
	}
	
	func configureCell(type: CellType) {
		self.cellType = type
		titleLabel.text = type.title
		inputTextField.placeholder = type.title
		
		inputTextField.inputView = nil
		inputTextField.keyboardType = .default
		inputTextField.addDoneButtonKeyboard()
		
		if type == .country {
			countryPicker.delegate = self
			countryPicker.selectedCountryName = "United States"
			inputTextField.text = "United States"
			inputTextField.delegate = self
			inputTextField.inputView = countryPicker
		} else if type == .email{
			inputTextField.keyboardType = .emailAddress
			
			let comButtonItem = UIBarButtonItem(title: ".com", style: .plain, target: self, action: #selector(didTapDotCom))
			inputTextField.addDoneButtonKeyboard(additionalButton: comButtonItem)
		}
	}
	
	private func setupCell() {
		textFieldContainer.layer.borderWidth = 1.0
		textFieldContainer.layer.borderColor = UIColor.darkGray.cgColor
	}
	
	@objc private func didTapDotCom() {
		inputTextField.text = (inputTextField.text ?? "") + ".com"
	}
    
}

extension RegistrationTableViewCell: CountryPickerDelegate {
	func countryPicker(_ picker: CountryPicker!, didSelectCountryWithName name: String!, code: String!) {
		inputTextField.text = name
	}
}

extension RegistrationTableViewCell: UITextFieldDelegate {
	func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
		guard cellType == .country else {
			return
		}
		
		textField.text = countryPicker.selectedCountryName
	}
}

extension RegistrationTableViewCell {
	enum CellType {
		case firstName
		case lastName
		case email
		case company
		case country
		case city
		
		var title: String {
			switch self {
			case .firstName:
				return "First Name"
			case .lastName:
				return "Last Name"
			case .email:
				return "Email"
			case .company:
				return "Company Name"
			case .country:
				return "Country/Region"
			case .city:
				return "City"
			}
		}
	}
}
