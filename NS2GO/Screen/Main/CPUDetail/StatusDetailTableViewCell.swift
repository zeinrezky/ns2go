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
		
		setBackgroundIndicator(alertLimits: alertLimits, busy: (diskInstance.dp2Busy ?? 0), qLength: (diskInstance.queueLength ?? 0))
	}
	
	func configureCell(alertLimits: [AlertLimit], cpuInstance: CPUProcessInstance) {
		nameLabel.text = cpuInstance.name
		busyLabel.text = "\(cpuInstance.cpuBusy ?? 0)%"
		lengthLabel.text = "\(cpuInstance.queueLength ?? 0)"
		
		setBackgroundIndicator(alertLimits: alertLimits, busy: (cpuInstance.cpuBusy ?? 0), qLength: (cpuInstance.queueLength ?? 0))
	}
	
	func setBackgroundIndicator(alertLimits: [AlertLimit], busy: Double, qLength: Double) {
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
		
		backgroundIndicator.backgroundColor = indicator.color
	}
    
}
