//
//  DualStatusListTableViewCell.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 21/10/21.
//

import UIKit

class DualStatusListTableViewCell: UITableViewCell {
	
	static let identifier = "DualStatusListTableViewCell"
	
	@IBOutlet weak var busyIndicator: UIView!
	@IBOutlet weak var busyLabel: UILabel!
	@IBOutlet weak var qLengthIndicator: UIView!
	@IBOutlet weak var qLengthLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		setupStatusView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func configureCell(alertLimits: [AlertLimit], instance: CPU) {
		busyLabel.text = "\(instance.cpuBusy ?? 0)% Busy"
		qLengthLabel.text = "\(instance.queueLength ?? 0) Q.Length"
		
		var busyStatusIndicator: StatusIndicator = .green
		
		if let busyAlert = alertLimits.first(where: {$0.entity == .busy}),
		   let warningDouble = Double(busyAlert.warning),
		   let criticalDouble = Double(busyAlert.critical) {
			
			if let value = instance.cpuBusy {
				if value >= criticalDouble {
					busyStatusIndicator = .red
				} else if value >= warningDouble {
					busyStatusIndicator = .yellow
				}
			}
		}
		
		self.busyIndicator.backgroundColor = busyStatusIndicator == .green ? AppColor.dotGreen : busyStatusIndicator.color
		
		var qLengthStatusIndicator: StatusIndicator = .green
		
		if let qLengthAlert = alertLimits.first(where: {$0.entity == .queueLength}),
		   let warningDouble = Double(qLengthAlert.warning),
		   let criticalDouble = Double(qLengthAlert.critical) {
			
			if let value = instance.queueLength {
				if value >= criticalDouble {
					qLengthStatusIndicator = .red
				} else if value >= warningDouble {
					qLengthStatusIndicator = .yellow
				}
			}
		}
		
		self.qLengthIndicator.backgroundColor = qLengthStatusIndicator == .green ? AppColor.dotGreen : qLengthStatusIndicator.color
	}
	
	func configureCell(alertLimits: [AlertLimit], instance: IPU) {
		busyLabel.text = "\(instance.ipubusy ?? 0)% Busy"
		qLengthLabel.text = "\(instance.ipuqtime ?? 0) Q.Length"
		
		var busyStatusIndicator: StatusIndicator = .green
		
		if let busyAlert = alertLimits.first(where: {$0.entity == .busy}),
		   let warningDouble = Double(busyAlert.warning),
		   let criticalDouble = Double(busyAlert.critical) {
			
			if let value = instance.ipubusy {
				if value >= criticalDouble {
					busyStatusIndicator = .red
				} else if value >= warningDouble {
					busyStatusIndicator = .yellow
				}
			}
		}
		
		self.busyIndicator.backgroundColor = busyStatusIndicator == .green ? AppColor.dotGreen : busyStatusIndicator.color
		
		var qLengthStatusIndicator: StatusIndicator = .green
		
		if let qLengthAlert = alertLimits.first(where: {$0.entity == .queueLength}),
		   let warningDouble = Double(qLengthAlert.warning),
		   let criticalDouble = Double(qLengthAlert.critical) {
			
			if let value = instance.ipuqtime {
				if value >= criticalDouble {
					qLengthStatusIndicator = .red
				} else if value >= warningDouble {
					qLengthStatusIndicator = .yellow
				}
			}
		}
		
		self.qLengthIndicator.backgroundColor = qLengthStatusIndicator == .green ? AppColor.dotGreen : qLengthStatusIndicator.color
	}
	
	private func setupStatusView() {
		busyIndicator.layer.cornerRadius = 6.0
		busyIndicator.layer.borderColor = UIColor.lightGray.cgColor
		busyIndicator.layer.borderWidth = 1
		
		qLengthIndicator.layer.cornerRadius = 6.0
		qLengthIndicator.layer.borderColor = UIColor.lightGray.cgColor
		qLengthIndicator.layer.borderWidth = 1
	}
}
