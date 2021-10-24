//
//  ObjectMonitored.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 17/10/21.
//

import Foundation
import SwiftyJSON

class ObjectMonitored {
	
	let category: Category
	var processorinfo: Processorinfo?
	var instance: [BaseInstance] = []
	var metrics: [String] = []
	
	init(json: JSON) {
		guard let categoryString = json["category"].string,
			  let category = Category(rawValue: categoryString) else {
			self.category = .none
			return
		}
		
		self.category = category
		self.processorinfo = Processorinfo(json: json["processorinfo"])
		
		if let metrics = json["metrics"].arrayObject as? [String] {
			self.metrics = metrics
		}
		
		if let jsonArray = json["instances"].array {
			switch category {
			case .TMF:
				let objects: [TMF] = populateInstance(jsonArray: jsonArray)
				self.instance = objects
			case .CLIMAgent:
				let objects: [CLIMAgent] = populateInstance(jsonArray: jsonArray)
				self.instance = objects
			case .CIPSSRV:
				let objects: [CIPSSRV] = populateInstance(jsonArray: jsonArray)
				self.instance = objects
			case .CPU:
				let objects: [CPU] = populateInstance(jsonArray: jsonArray)
				self.instance = objects.sorted(by: { (left, right) -> Bool in
					return (left.name ?? "") < (right.name ?? "")
				})
			case .Busy:
				let objects: [CPUProcessInstance] = populateInstance(jsonArray: jsonArray)
				self.instance = objects.sorted(by: { (left, right) -> Bool in
					return (left.name ?? "") < (right.name ?? "")
				})
			case .QueueLength:
				let objects: [CPUProcessInstance] = populateInstance(jsonArray: jsonArray)
				self.instance = objects.sorted(by: { (left, right) -> Bool in
					return (left.name ?? "") < (right.name ?? "")
				})
			case .DiskBusy:
				let objects: [DiskProcessInstance] = populateInstance(jsonArray: jsonArray)
				self.instance = objects.sorted(by: { (left, right) -> Bool in
					return (left.name ?? "") < (right.name ?? "")
				})
			case .DiskQueueLength:
				let objects: [DiskProcessInstance] = populateInstance(jsonArray: jsonArray)
				self.instance = objects.sorted(by: { (left, right) -> Bool in
					return (left.name ?? "") < (right.name ?? "")
				})
			case .none:
				break
			}
		}
	}
	
	func populateInstance<T: BaseInstance>(jsonArray: [JSON]) -> [T] {
		var objects: [T] = []
		
		for json in jsonArray {
			let object = T(json: json)
			objects.append(object)
		}
		
		return objects
	}
	
	func getIndicator(alertLimits: [AlertLimit]) -> StatusIndicator{
		var indicator: StatusIndicator = .green
		guard let object = alertLimits.first?.object else {
			return indicator
		}
		
		switch object {
		case .CPU:
			if let instances = instance as? [CPU] {
				instances.forEach { (instance) in
					let filteredAlert = alertLimits.filter({$0.object == .CPU})
					let instanceIndicator = instance.getIndicator(alertLimits: filteredAlert)
					indicator = indicator.compareHigher(indicator: instanceIndicator)
				}
			}
		case .IPU:
			if let instances = instance as? [CPU] {
				instances.forEach { (instance) in
					let filteredAlert = alertLimits.filter({$0.object == .IPU})
					let instanceIndicator = instance.getIPUIndicator(alertLimits: filteredAlert)
					indicator = indicator.compareHigher(indicator: instanceIndicator)
				}
			}
		case .Disk:
			if let instances = instance as? [DiskProcessInstance] {
				instances.forEach { (instance) in
					let filteredAlert = alertLimits.filter({$0.object == .Disk})
					let instanceIndicator = instance.getIndicator(alertLimits: filteredAlert)
					indicator = indicator.compareHigher(indicator: instanceIndicator)
				}
			}
		case .Process:
			if let instances = instance as? [CPUProcessInstance] {
				instances.forEach { (instance) in
					let filteredAlert = alertLimits.filter({$0.object == .Process})
					let instanceIndicator = instance.getIndicator(alertLimits: filteredAlert)
					indicator = indicator.compareHigher(indicator: instanceIndicator)
				}
			}
		default:
			break
		}
		
		return indicator
	}
	
	enum Category: String {
		case TMF = "TMF"
		case CLIMAgent = "CLIMAgent"
		case CIPSSRV = "CIPSSRV"
		case CPU = "CPU"
		case Busy = "Process-% CPU Busy"
		case QueueLength = "Process-Queue Length"
		case DiskBusy = "Disk-% DP2 Busy"
		case DiskQueueLength = "Disk-Queue Length"
		case none
	}
}


// MARK: - Processorinfo
class Processorinfo {
	let updown: String?

	init(json: JSON) {
		self.updown = json["updown"].string
	}
}
