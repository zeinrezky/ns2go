//
//  StatusDetailTableViewCell.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 11/10/21.
//

import UIKit

class StatusDetailTableViewCell: UITableViewCell {
	
	static let identifier = "StatusDetailTableViewCell"
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var busyLabel: UILabel!
	@IBOutlet weak var lengthLabel: UILabel!
	
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
	
	func configureCell(alertLimits: [AlertLimit], diskInstance: DiskProcessInstance) {
		nameLabel.text = diskInstance.name
		busyLabel.text = "\(diskInstance.dp2Busy ?? 0)%"
		lengthLabel.text = "\(diskInstance.queueLength ?? 0)"
		
		let indicator = getIndicator(alertLimits: alertLimits, busy: (diskInstance.dp2Busy ?? 0), qLength: (diskInstance.queueLength ?? 0))
		setupViewFor(indicator: indicator)
	}
	
	func configureCell(alertLimits: [AlertLimit], cpuInstance: CPUProcessInstance) {
		let isNameEmpty = (cpuInstance.name ?? "").isEmpty
		let CPUPINName = "\(cpuInstance.cpuDisplayName),\(cpuInstance.pin ?? 0)"
		let name = isNameEmpty ? CPUPINName : cpuInstance.name
		nameLabel.text = name
		busyLabel.text = "\(cpuInstance.cpuBusy ?? 0)%"
		lengthLabel.text = "\(cpuInstance.queueLength ?? 0)"
		
		let indicator = getIndicator(alertLimits: alertLimits, busy: (cpuInstance.cpuBusy ?? 0), qLength: (cpuInstance.queueLength ?? 0))
		setupViewFor(indicator: indicator)
	}
	
	private func setupViewFor(indicator: StatusListTableViewCell.StatusIndicator) {
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
	}
	
	private func getIndicator(alertLimits: [AlertLimit], busy: Double, qLength: Double) -> StatusListTableViewCell.StatusIndicator {
		var indicator: StatusListTableViewCell.StatusIndicator = .clear
		
		if let busyLimit = alertLimits.first(where: {$0.entity == .busy}) {
			if let warning = Double(busyLimit.warning),
			   let critical = Double(busyLimit.critical) {
				
				if busy >= critical {
					indicator = indicator.compareHigher(indicator: .red)
				} else if busy >= warning {
					indicator = indicator.compareHigher(indicator: .yellow)
				}
			}
		}
		
		if let lengthLimit = alertLimits.first(where: {$0.entity == .queueLength}) {
			if let warning = Double(lengthLimit.warning),
			   let critical = Double(lengthLimit.critical) {
				
				if qLength >= critical {
					indicator = indicator.compareHigher(indicator: .red)
				} else if qLength >= warning {
					indicator = indicator.compareHigher(indicator: .yellow)
				}
			}
		}
		
		return indicator
	}
    
}
