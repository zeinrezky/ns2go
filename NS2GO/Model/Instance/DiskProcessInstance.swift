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
}
