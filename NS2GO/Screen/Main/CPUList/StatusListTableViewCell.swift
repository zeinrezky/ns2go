//
//  StatusListTableViewCell.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 11/10/21.
//

import UIKit

class StatusListTableViewCell: UITableViewCell {
	
	static let identifier = "StatusListTableViewCell"
	
	
	@IBOutlet weak var alertTypeLabel: UILabel!
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
	
	func configureCell(text: String, topProcess: DiskProcessInstance, alert: AlertLimit) {
		alertTypeLabel.text = text
		let indicator = topProcess.getIndicator(alertLimits: [alert])
		statusIndicatorView.backgroundColor = indicator == .green || indicator == .clear ? AppColor.dotGreen : indicator.color
		
		let numberFormatter = NumberFormatter()
		numberFormatter.minimumFractionDigits = 2
		let name = topProcess.name?.isEmpty == false ? (topProcess.name ?? "") : "\(topProcess.cpunumber ?? ""), \(topProcess.pin ?? "")"
		
		if alert.entity == .busy {
			statusLabel.text = "\(name)   \(numberFormatter.string(from: NSNumber(value: topProcess.dp2Busy ?? 0)) ?? "")%"
		} else if alert.entity == .queueLength {
			statusLabel.text = "\(name)   \(numberFormatter.string(from: NSNumber(value: topProcess.queueLength ?? 0)) ?? "")"
		}
	}
	
	func configureCell(text: String, topProcess: CPUProcessInstance, alert: AlertLimit) {
		alertTypeLabel.text = text
		let indicator = topProcess.getIndicator(alertLimits: [alert])
		statusIndicatorView.backgroundColor = indicator == .green || indicator == .clear ? AppColor.dotGreen : indicator.color
		
		let numberFormatter = NumberFormatter()
		numberFormatter.minimumFractionDigits = 2
		
		let name = topProcess.name?.isEmpty == false ? (topProcess.name ?? "") : "\(topProcess.cpunumber ?? 0), \(topProcess.pin ?? 0)"
		
		if alert.entity == .busy {
			statusLabel.text = "\(name)   \(numberFormatter.string(from: NSNumber(value: topProcess.cpuBusy ?? 0)) ?? "")%"
		} else if alert.entity == .queueLength {
			statusLabel.text = "\(name)   \(numberFormatter.string(from: NSNumber(value: topProcess.queueLength ?? 0)) ?? "")"
		}
	}
	
	private func setupStatusView() {
		statusIndicatorView.layer.cornerRadius = 6.0
		statusIndicatorView.layer.borderColor = UIColor.lightGray.cgColor
		statusIndicatorView.layer.borderWidth = 1
	}
    
}
