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
		
		var entity: AlertLimit.EntityType? = nil
		
		if alertLimits.count == 1, let alert = alertLimits.first {
			entity = alert.entity
		}
		
		setupViewFor(indicator: indicator, for: entity)
	}
	
	private func setupViewFor(indicator: StatusIndicator, for entity: AlertLimit.EntityType?) {
		backgroundIndicator.backgroundColor = indicator.color
		
		let boldFont = UIFont.systemFont(ofSize: 12, weight: .bold)
		let normalFont = UIFont.systemFont(ofSize: 12)
		
		busyLabel.font = normalFont
		lengthLabel.font = normalFont
		
		if indicator == .red || indicator == .yellow {
			if let entity = entity {
				switch entity {
				case .busy:
					busyLabel.font = boldFont
				case .queueLength:
					lengthLabel.font = boldFont
				default:
					break
				}
			} else {
				busyLabel.font = boldFont
				lengthLabel.font = boldFont
			}
		}
	}
}
