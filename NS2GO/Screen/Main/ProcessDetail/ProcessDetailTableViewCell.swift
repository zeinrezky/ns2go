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
		
		let numberFormatter = NumberFormatter()
		numberFormatter.minimumFractionDigits = 2
		
		let isNameEmpty = (cpuInstance.name ?? "").isEmpty
		let CPUPINName = "\(cpuInstance.cpuDisplayName),\(cpuInstance.pin ?? 0)"
		let name = isNameEmpty ? CPUPINName : cpuInstance.name
		nameLabel.text = name
		busyLabel.text = "\(numberFormatter.string(from: NSNumber(value: cpuInstance.cpuBusy ?? 0)) ?? "")%"
		lengthLabel.text = "\(numberFormatter.string(from: NSNumber(value: cpuInstance.queueLength ?? 0)) ?? "")"
		cpuLabel.text = "\(cpuInstance.cpuDisplayName)"
		pinLabel.text = "\(cpuInstance.pin ?? 0)"
		
		let busyIndicator = cpuInstance.getBusyIndicator(alertLimits: alertLimits)
		let qlengthIndicator = cpuInstance.getQLenghtIndicator(alertLimits: alertLimits)
		setupViewFor(busy: busyIndicator, qlength: qlengthIndicator)
	}
	
	private func setupViewFor(indicator: StatusIndicator, for entity: AlertLimit.EntityType?) {
		backgroundIndicator.backgroundColor = indicator.color
		
		let boldFont = UIFont(name: "HelveticaNeue-Bold", size: 12)
		let normalFont = UIFont(name: "HelveticaNeue", size: 12)
		
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
	
	private func setupViewFor(busy: StatusIndicator, qlength: StatusIndicator) {
		let indicator = busy.compareHigher(indicator: qlength)
		backgroundIndicator.backgroundColor = indicator.color
		
		let boldFont = UIFont(name: "HelveticaNeue-Bold", size: 12)
		let normalFont = UIFont(name: "HelveticaNeue", size: 12)
		
		if busy == .yellow || busy == .red {
			busyLabel.font = boldFont
		} else {
			busyLabel.font = normalFont
		}

		if qlength == .yellow || qlength == .red {
			lengthLabel.font = boldFont
		} else {
			lengthLabel.font = normalFont
		}
	}
}
