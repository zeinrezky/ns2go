//
//  StatusListTableViewCell.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 11/10/21.
//

import UIKit

class StatusListTableViewCell: UITableViewCell {
	
	static let identifier = "StatusListTableViewCell"
	
	@IBOutlet weak var statusIndicatorView: UIView!
	@IBOutlet weak var statusLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		setupStatusView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func configureCell(status: StatusIndicator, text: String) {
		statusIndicatorView.backgroundColor = status.color
		statusLabel.text = text
	}
	
	private func setupStatusView() {
		statusIndicatorView.layer.cornerRadius = 6.0
		statusIndicatorView.layer.borderColor = UIColor.lightGray.cgColor
		statusIndicatorView.layer.borderWidth = 1
	}
    
}

extension StatusListTableViewCell {
	
	enum StatusIndicator {
		case green
		case yellow
		case red
		
		var color: UIColor {
			switch self {
			case .green:
				return UIColor(red: 60.0/255.0, green: 244.0/255.0, blue: 110.0/255.0, alpha: 1)
			case .yellow:
				return UIColor(red: 250.0/255.0, green: 244.0/255.0, blue: 104.0/255.0, alpha: 1)
			case .red:
				return UIColor(red: 253.0/255.0, green: 165.0/255.0, blue: 154.0/255.0, alpha: 1)
			}
		}
	}
	
}
