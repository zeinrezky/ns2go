//
//  RegistrationTableViewCell.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 09/10/21.
//

import UIKit

class RegistrationTableViewCell: UITableViewCell {
	
	static let identifier: String = "RegistrationTableViewCell"
	
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var textFieldContainer: UIView!
	@IBOutlet weak var inputTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
		setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func configureCell(type: CellType) {
		titleLabel.text = type.title
		inputTextField.placeholder = type.title
	}
	
	private func setupCell() {
		textFieldContainer.layer.borderWidth = 1.0
		textFieldContainer.layer.borderColor = UIColor.darkGray.cgColor
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
		
//		var placeholderText: String {
//			switch self {
//			case .firstName:
//				<#code#>
//			case .lastName:
//				<#code#>
//			case .email:
//				<#code#>
//			case .company:
//				<#code#>
//			case .country:
//				<#code#>
//			case .city:
//				<#code#>
//			}
//		}
	}
}
