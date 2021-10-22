//
//  ServiceHelper.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 19/10/21.
//

import Foundation

class ServiceHelper {
	static let shared = ServiceHelper()

	var nodeAlert: Node?
	var nodeStatuses: [NodeStatus] = []
	var lastFetchTime: Date = Date()
	
	var nodeAlertJSON: [String: Any]? = [:]
	var nodeStatusesJSON: [String: Any]? = [:]
	var versionJSON: [String: Any]? = [:]
	
	var version: String?
	
	var successCompletions: [(() -> Void)] = []
	var errorCompletions: [((String) -> Void)] = []
	
	private let service = DashboardService()
	
	init() {
		
	}
	
	func addSuccessCompletion(_ completion: @escaping () -> Void) {
		successCompletions.append(completion)
	}
	
	func addErrorCompletion(_ completion: @escaping (String) -> Void) {
		errorCompletions.append(completion)
	}
	
	func fetchStatusData() {
		service.getCurrentStatus(onComplete: { [weak self] json, nodeStatus in
			self?.lastFetchTime = Date()
			self?.nodeStatusesJSON = json
			
			if let alerts = self?.nodeAlert?.alertlimits {
				nodeStatus.alertLimits = alerts
			}
			
			self?.nodeStatuses = [nodeStatus]
			
			self?.successCompletions.forEach { (completion) in
				completion()
			}
			
		}, onFailed: { [weak self] message in
			self?.errorCompletions.forEach { (completion) in
				completion(message)
			}
		})
	}
	
	func getVersion(onComplete: @escaping(String) -> Void) {
		service.getCurrentVersion(onComplete: { [weak self] (json, version) in
			self?.version = version
			self?.versionJSON = json
			onComplete(version)
		}, onFailed: nil)
	}
	
}
