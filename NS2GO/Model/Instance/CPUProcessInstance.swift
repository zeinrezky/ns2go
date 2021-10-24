//
//  CPUProcessInstance.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 17/10/21.
//

import Foundation
import SwiftyJSON

class CPUProcessInstance: BaseInstance {
	let cpunumber: Int?
	let pin: Int?
	let ipunumber: Int?
	let priority: Int?
	let owner: String?
	let program: String?
	let fullprogram: String?
	let processtype: Int?
	let osspathname: String?
	let osspid: Int?
	let ancestor: String?
	let cpuBusy: Double?
	let beginXNS: Int?
	let abortXNS: Int?
	let queueLength: Double?
	let receiveQueue: Double?
	let memoryUsed: Double?
	
	var cpuDisplayName: String {
		var displayName: String = ""
		
		if let number = cpunumber {
			
			let formatter = NumberFormatter()
			formatter.minimumIntegerDigits = 2
			
			displayName = "\(formatter.string(for: number) ?? "")"
		}
		
		return displayName
	}

	required init(json: JSON) {
		self.cpunumber = json["CPUNUMBER"].int
		self.pin = json["PIN"].int
		self.ipunumber = json["IPUNUMBER"].int
		self.priority = json["PRIORITY"].int
		self.owner = json["OWNER"].string
		self.program = json["PROGRAM"].string
		self.fullprogram = json["FULLPROGRAM"].string
		self.processtype = json["PROCESSTYPE"].int
		self.osspathname = json["OSSPATHNAME"].string
		self.osspid = json["OSSPID"].int
		self.ancestor = json["ANCESTOR"].string
		self.cpuBusy = json["% CPU Busy"].double
		self.beginXNS = json["Begin Xns"].int
		self.abortXNS = json["Abort Xns"].int
		self.queueLength = json["Queue Length"].double
		self.receiveQueue = json["Receive Queue"].double
		self.memoryUsed = json["Memory Used"].double
		
		super.init(json: json)
	}
	
	func getBusyIndicator(alertLimits: [AlertLimit]) -> StatusIndicator {
		var indicator: StatusIndicator = .clear
		if alertLimits.count == 0 {
			return indicator
		}
		
		if let busy = cpuBusy,
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
	
	func getQLenghtIndicator(alertLimits: [AlertLimit]) -> StatusIndicator {
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
	
	func getIndicator(alertLimits: [AlertLimit]) -> StatusIndicator {
		let busyIndicator = getBusyIndicator(alertLimits: alertLimits)
		let qLengthIndicator = getQLenghtIndicator(alertLimits: alertLimits)
		
		return busyIndicator.compareHigher(indicator: qLengthIndicator)
	}
}
