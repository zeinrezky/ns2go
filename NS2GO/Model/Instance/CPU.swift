//
//  CPU.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 17/10/21.
//

import Foundation
import SwiftyJSON
// MARK: - Instance
class CPU: BaseInstance {
	let cpuBusy: Double?
	let queueLength: Double?
	let memoryUsed: Double?
	let tle: Int?
	let lowPINPCBs: Int?
	let ipucount: Int?
	var ipus: [IPU] = []
	
	var displayName: String {
		var displayName: String = ""
		
		if let cpuDouble = Double(self.name ?? "") {
			
			let formatter = NumberFormatter()
			formatter.minimumIntegerDigits = 2
			
			displayName = "\(formatter.string(for: cpuDouble) ?? "")"
		}
		
		return displayName
	}

	required init(json: JSON) {
		self.cpuBusy = json["% CPU Busy"].double
		self.queueLength = json["Queue Length"].double
		self.memoryUsed = json["Memory Used"].double
		self.tle = json["% TLE"].int
		self.lowPINPCBs = json["% Low PIN PCBs"].int
		self.ipucount = json["IPUCOUNT"].int
		
		if let jsonArray = json["IPUS"].array {
			var objectIPUS: [IPU] = []
			for jsonObject in jsonArray {
				let ipu = IPU(json: jsonObject, cpuJSON: json)
				objectIPUS.append(ipu)
			}
			self.ipus = objectIPUS
		}
		
		super.init(json: json)
	}
}

// MARK: - Ipus
class IPU {
	let cpuName: String?
	let ipunumber: Int?
	let ipubusy: Double?
	let ipuqtime: Double?
	
	var displayName: String {
		var name: String = ""
		
		if let cpuDouble = Double(cpuName ?? ""),
		   let ipu = ipunumber {
			
			let formatter = NumberFormatter()
			formatter.minimumIntegerDigits = 2
			
			name = "\(formatter.string(for: cpuDouble) ?? "").\(formatter.string(for: ipu) ?? "")"
		}
		
		return name
	}

	init(json: JSON, cpuJSON: JSON) {
		self.cpuName = cpuJSON["name"].string ?? String(cpuJSON["name"].intValue)
		self.ipunumber = json["IPUNUMBER"].int
		self.ipubusy = json["IPUBUSY"].double
		self.ipuqtime = json["IPUQTIME"].double
	}
}
