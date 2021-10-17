//
//  AlertLimit.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 17/10/21.
//

import Foundation
import SwiftyJSON

class AlertLimit {
	let object: String
	let entity: String
	let warning: String
	let critical: String
	let monitor: String
	
	init(json: JSON) {
		object = json["object"].stringValue
		entity = json["entity"].stringValue
		warning = json["warning"].stringValue
		critical = json["critical"].stringValue
		monitor = json["monitor"].stringValue
	}
}
