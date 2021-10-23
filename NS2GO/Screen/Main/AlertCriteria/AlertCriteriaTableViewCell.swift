//
//  AlertCriteriaTableViewCell.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 23/10/21.
//

import UIKit

class AlertCriteriaTableViewCell: UITableViewCell {
	
	static let identifier: String = "AlertCriteriaTableViewCell"
	
	@IBOutlet weak var busyNameLabel: UILabel!
	@IBOutlet weak var busyWarningLabel: UILabel!
	@IBOutlet weak var busyCriticalLabel: UILabel!
	
	@IBOutlet weak var qLengthNameLabel: UILabel!
	@IBOutlet weak var qLengthWarningLabel: UILabel!
	@IBOutlet weak var qLengthCriticalLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func configureCell(busyAlert: AlertLimit, qLengthAlert: AlertLimit) {
		
		busyNameLabel.text = busyAlert.entity.rawValue
		busyWarningLabel.text = "\(busyAlert.warning)-\(busyAlert.critical)%"
		busyCriticalLabel.text = "> \(busyAlert.critical)%"
		
		qLengthNameLabel.text = qLengthAlert.entity.rawValue
		qLengthWarningLabel.text = "\(qLengthAlert.warning)-\(busyAlert.critical)"
		qLengthCriticalLabel.text = "> \(qLengthAlert.critical)"
	}
    
}
