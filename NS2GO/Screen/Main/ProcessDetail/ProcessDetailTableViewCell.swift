//
//  ProcessDetailTableViewCell.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 11/10/21.
//

import UIKit

class ProcessDetailTableViewCell: UITableViewCell {
	
	static let identifier = "ProcessDetailTableViewCell"
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var busyLabel: UILabel!
	@IBOutlet weak var lengthLabel: UILabel!
	@IBOutlet weak var cpuLabel: UILabel!
	@IBOutlet weak var pinLabel: UILabel!
	
	@IBOutlet weak var backgroundIndicator: UIView!
	override func awakeFromNib() {
        super.awakeFromNib()
		selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func configureCell(alertLimits: [AlertLimit], cpuInstance: CPUProcessInstance) {
		let isNameEmpty = (cpuInstance.name ?? "").isEmpty
		let CPUPINName = "\(cpuInstance.cpuDisplayName),\(cpuInstance.pin ?? 0)"
		let name = isNameEmpty ? CPUPINName : cpuInstance.name
		nameLabel.text = name
		busyLabel.text = "\(cpuInstance.cpuBusy ?? 0)%"
		lengthLabel.text = "\(cpuInstance.queueLength ?? 0)"
		cpuLabel.text = "\(cpuInstance.cpuDisplayName)"
		pinLabel.text = "\(cpuInstance.pin ?? 0)"
		
		let indicator = cpuInstance.getIndicator(alertLimits: alertLimits)
		setupViewFor(indicator: indicator)
	}
	
	private func setupViewFor(indicator: StatusIndicator) {
		backgroundIndicator.backgroundColor = indicator.color
		
		let font: UIFont
		if indicator == .yellow || indicator == .red {
			font = UIFont.systemFont(ofSize: 12, weight: .bold)
		} else {
			font = UIFont.systemFont(ofSize: 12)
		}
		
		nameLabel.font = font
		busyLabel.font = font
		lengthLabel.font = font
		cpuLabel.font = font
		pinLabel.font = font
	}
}
