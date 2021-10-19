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
	
	var alertLimits: [AlertLimit] = []
	
	var indicator: StatusIndicator {
		var indicator: StatusIndicator = .green
		
		let filteredCPUAlert = alertLimits.filter({$0.object == .CPU})
		let filteredIPUAlert = alertLimits.filter({$0.object == .IPU})
		let filteredDiskAlert = alertLimits.filter({$0.object == .Disk})
		let filteredProcessAlert = alertLimits.filter({$0.object == .Process})
		monitors.forEach { (monitor) in
			switch monitor.category {
			case .Busy:
				let cpuIndicator = monitor.getIndicator(alertLimits: filteredCPUAlert)
				let ipuIndicator = monitor.getIndicator(alertLimits: filteredIPUAlert)
				let ProcessIndicator = monitor.getIndicator(alertLimits: filteredProcessAlert)
				indicator = indicator.compareHigher(indicator: ProcessIndicator)
				indicator = indicator.compareHigher(indicator: cpuIndicator)
				indicator = indicator.compareHigher(indicator: ipuIndicator)
			case .QueueLength:
				let ProcessIndicator = monitor.getIndicator(alertLimits: filteredProcessAlert)
				indicator = indicator.compareHigher(indicator: ProcessIndicator)
			case .DiskBusy, .DiskQueueLength:
				let diskIndicator = monitor.getIndicator(alertLimits: filteredDiskAlert)
				indicator = indicator.compareHigher(indicator: diskIndicator)
			case .CPU:
				let cpuIndicator = monitor.getIndicator(alertLimits: filteredCPUAlert)
				let ipuIndicator = monitor.getIndicator(alertLimits: filteredIPUAlert)
				indicator = indicator.compareHigher(indicator: cpuIndicator)
				indicator = indicator.compareHigher(indicator: ipuIndicator)
			default:
				break
			}
		}
		
		return indicator
	}
	
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
