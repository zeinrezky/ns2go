//
//  AlertLimit.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 17/10/21.
//

import Foundation
import SwiftyJSON

class AlertLimit {
	let object: ObjectType
	let entity: EntityType
	let warning: String
	let critical: String
	let monitor: String
	let entityString: String
	
	init(json: JSON) {
		self.warning = json["warning"].stringValue
		self.critical = json["critical"].stringValue
		self.monitor = json["monitor"].stringValue
	
		if let objectString = json["object"].string,
		   let object = ObjectType(rawValue: objectString) {
			self.object = object
		} else {
			self.object = .none
		}
		
		if let entityString = json["entity"].string {
			self.entityString = entityString
			if let entity = EntityType(rawValue: entityString) {
				self.entity = entity
			} else if entityString.lowercased().contains("busy") {
				self.entity = .busy
			} else {
				self.entity = .none
			}
		} else {
			self.entityString = ""
			self.entity = .none
		}
		
	}
	
	enum ObjectType: String {
		case CLIM = "CLIM"
		case CPU = "CPU"
		case Disk = "Disk"
		case IPU = "IPU"
		case Process = "Process"
		case Network = "Network"
		case TMF = "TMF"
		case none
	}
	
	enum EntityType: String {
		case CLIMBusy = "CLIM % Busy"
		case CLIMMemory = "CLIM Mem Used %"
		case busy = "% Busy"
		case lowPinCBS = "% Low PIN PCBs"
		case memory = "% Memory"
		case TLE = "% TLE"
		case queueLength = "Queue Length"
		case receiveMessage = "Recv Msgs"
		case sentMessage = "Sent Msgs"
		case receiveQueue = "Receive Queue"
		case abort = "% Abort"
		case none
	}
}
