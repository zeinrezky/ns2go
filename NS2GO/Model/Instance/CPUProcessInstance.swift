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
	let memoryUsed: Double?

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
		self.memoryUsed = json["Memory Used"].double
		
		super.init(json: json)
	}
}
