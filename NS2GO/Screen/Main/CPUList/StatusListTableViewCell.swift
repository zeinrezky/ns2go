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
	
	func configureCell(alertLimit: AlertLimit?, instance: CPU, row: Int) {
		if row == 0 {
			statusLabel.text = "\(instance.cpuBusy ?? 0)% Busy"
		} else if row == 1 {
			statusLabel.text = "\(instance.queueLength ?? 0) Q.Length"
		}
		
		var indicator: StatusIndicator = .green
		
		if let warning = alertLimit?.warning,
		   let critical = alertLimit?.critical,
		   let warningDouble = Double(warning),
		   let criticalDouble = Double(critical) {
			
			if let value = row == 0 ? instance.cpuBusy : instance.queueLength {
				if value >= criticalDouble {
					indicator = .red
				} else if value >= warningDouble {
					indicator = .yellow
				}
			}
		}
		
		statusIndicatorView.backgroundColor = indicator == .green ? AppColor.dotGreen : indicator.color
	}
	
	func configureCell(alertLimit: AlertLimit?, instance: IPU, row: Int) {
		if row == 0 {
			statusLabel.text = "\(instance.ipubusy ?? 0)% Busy"
		} else if row == 1 {
			statusLabel.text = "\(instance.ipuqtime ?? 0) Q.Length"
		}
		
		var indicator: StatusIndicator = .green
		
		if let warning = alertLimit?.warning,
		   let critical = alertLimit?.critical,
		   let warningDouble = Double(warning),
		   let criticalDouble = Double(critical) {
			
			if let value = row == 0 ? instance.ipubusy : instance.ipuqtime {
				if value >= criticalDouble {
					indicator = .red
				} else if value >= warningDouble {
					indicator = .yellow
				}
			}
		}
		
		statusIndicatorView.backgroundColor = indicator == .green ? AppColor.dotGreen : indicator.color
	}
	
	private func setupStatusView() {
		statusIndicatorView.layer.cornerRadius = 6.0
		statusIndicatorView.layer.borderColor = UIColor.lightGray.cgColor
		statusIndicatorView.layer.borderWidth = 1
	}
    
}
