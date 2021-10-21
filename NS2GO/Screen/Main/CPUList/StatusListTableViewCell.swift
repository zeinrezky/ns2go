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
		statusIndicatorView.backgroundColor = status == .green ? AppColor.dotGreen : status.color
		statusLabel.text = text
	}
	
	private func setupStatusView() {
		statusIndicatorView.layer.cornerRadius = 6.0
		statusIndicatorView.layer.borderColor = UIColor.lightGray.cgColor
		statusIndicatorView.layer.borderWidth = 1
	}
    
}
