//
//  DiskProcessInstance.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 17/10/21.
//

import Foundation
import SwiftyJSON

// MARK: - DiskProcess
class DiskProcessInstance: BaseInstance {
	let smplskpd: Int?
	let cpunumber: String?
	let pin: String?
	let dp2Busy: Double?
	let queueLength: Double?
	let deviceqbusy: Double?
	let readqbusy: Double?
	let writeqbusy: Double?
	let cachehitrate: Double?

	required init(json: JSON) {
		self.smplskpd = json["SMPLSKPD"].int
		self.cpunumber = json["CPUNUMBER"].string
		self.pin = json["PIN"].string
		self.dp2Busy = json["% DP2 Busy"].double
		self.queueLength = json["Queue Length"].double
		self.deviceqbusy = json["DEVICEQBUSY"].double
		self.readqbusy = json["READQBUSY"].double
		self.writeqbusy = json["WRITEQBUSY"].double
		self.cachehitrate = json["CACHEHITRATE"].double
		
		super.init(json: json)
	}
	
	func getIndicator(alertLimits: [AlertLimit]) -> StatusIndicator {
		let busyIndicator = getBusyIndicator(alertLimits: alertLimits)
		let qLengthIndicator = getQLengthIndicator(alertLimits: alertLimits)
		
		return busyIndicator.compareHigher(indicator: qLengthIndicator)
	}
	
	func getBusyIndicator(alertLimits: [AlertLimit]) -> StatusIndicator {
		var indicator: StatusIndicator = .clear
		if alertLimits.count == 0 {
			return indicator
		}
		
		if let busy = dp2Busy,
		   let busyLimit = alertLimits.first(where: {$0.entity == .busy}) {
			if let warning = Double(busyLimit.warning),
			   let critical = Double(busyLimit.critical) {
				
				if busy >= critical {
					indicator = indicator.compareHigher(indicator: .red)
				} else if busy >= warning {
					indicator = indicator.compareHigher(indicator: .yellow)
				}
			}
		}
		
		return indicator
	}
	
	func getQLengthIndicator(alertLimits: [AlertLimit]) -> StatusIndicator {
		var indicator: StatusIndicator = .clear
		if alertLimits.count == 0 {
			return indicator
		}
		
		if let qLength = queueLength,
		   let lengthLimit = alertLimits.first(where: {$0.entity == .queueLength}) {
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
