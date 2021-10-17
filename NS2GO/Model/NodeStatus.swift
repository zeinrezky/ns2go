//
//  NodeStatus.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 17/10/21.
//

import Foundation
import SwiftyJSON

class NodeStatus {
	let nodename: String?
	let producerName: String?
	let productName: String?
	let productVersion: String?
	var monitors: [ObjectMonitored] = []
	
	init(json: JSON) {
		self.nodename = json["nodename"].string
		self.producerName = json["producer-name"].string
		self.productName = json["product-name"].string
		self.productVersion = json["product-version"].string
		
		if let jsonArray = json["monitors"].array {
			var monitors: [ObjectMonitored] = []
			for jsonObject in jsonArray {
				let monitor = ObjectMonitored(json: jsonObject)
				monitors.append(monitor)
			}
			self.monitors = monitors
		}
	}
}
