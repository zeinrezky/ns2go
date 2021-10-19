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
		nameLabel.text = cpuInstance.name ?? "\(cpuInstance.cpuDisplayName),\(cpuInstance.pin ?? 0)"
		busyLabel.text = "\(cpuInstance.cpuBusy ?? 0)%"
		lengthLabel.text = "\(cpuInstance.receiveQueue ?? 0)"
		cpuLabel.text = "\(cpuInstance.cpuDisplayName)"
		pinLabel.text = "\(cpuInstance.pin ?? 0)"
		
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
		cpuLabel.font = font
		pinLabel.font = font
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
