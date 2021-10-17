//
//  Node.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 17/10/21.
//

import Foundation
import SwiftyJSON

class Node {
	
	let nodename: String
	let serialnumberError: Int
	let sysnum: String
	let command: String
	let status: String
	let tokencode: String
	let tnsVersion: String
	let logoninfo: String
	let timezone: Timezone
	let alertlimits: [AlertLimit]
	let processorstatus: String
	let allprocessorcount: String
	let processorcount: String
	let wasap: Int
	let pathway: Int
	
	init(json: JSON) {
		nodename = json["nodename"].stringValue
		serialnumberError = json["serialnumber_error"].intValue
		sysnum = json["sysnum"].stringValue
		command = json["command"].stringValue
		status = json["status"].stringValue
		tokencode = json["tokencode"].stringValue
		tnsVersion = json["tns_version"].stringValue
		logoninfo = json["logoninfo"].stringValue
		timezone = Timezone(json: json["timezone"])
		processorstatus = json["processorstatus"].stringValue
		allprocessorcount = json["allprocessorcount"].stringValue
		processorcount = json["processorcount"].stringValue
		wasap = json["wasap"].intValue
		pathway = json["pathway"].intValue
		
		
		var alerts: [AlertLimit] = []
		for object in json["alertlimits"].arrayValue {
			let alert = AlertLimit(json: object)
			alerts.append(alert)
		}
		alertlimits = alerts
	}
	
}

// MARK: - Timezone
class Timezone {
	let localtime: String
	let gmttime: String
	
	init(json: JSON) {
		localtime = json["localtime"].stringValue
		gmttime = json["gmttime"].stringValue
	}
}

