//
//  ServiceHelper.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 19/10/21.
//

import Foundation

class ServiceHelper {
	static let shared = ServiceHelper()
	
	let whitelistVersion: [String] = ["H01AAQ","L01AAR"]
	
	var username: String = ""
	var password: String = ""
	
	var neighborhood: [Neighborhood] = []
	var nodeAlert: [Node] = []
	var nodeStatuses: [NodeStatus] = []
	var versions: [Version] = []
	
	var lastFetchTime: Date = Date()
	
	var successCompletions: [(() -> Void)] = []
	var errorCompletions: [((String) -> Void)] = []
	
	
	var nodeConnectionStatuses: [String: NodeConnectionStatus] = [:] {
		didSet {
			onChangeConnectionStatus?()
		}
	}
	
	
	var onChangeConnectionStatus: (() -> Void)?
	
	private var whitelistedNeighborhood: [Neighborhood] = []
	
	private let service = DashboardService()
	private let loginService = LoginService()
	init() {
		
	}
	
	func reset() {
		nodeAlert = []
		neighborhood = []
		nodeStatuses = []
		versions = []
		lastFetchTime = Date()
		successCompletions.removeAll()
		errorCompletions.removeAll()
	}
	
	func addSuccessCompletion(_ completion: @escaping () -> Void) {
		successCompletions.append(completion)
	}
	
	func addErrorCompletion(_ completion: @escaping (String) -> Void) {
		errorCompletions.append(completion)
	}
	
	func saveCredential() {
		UserDefaults.standard.setValue(username, forKey: NS2GOConstant.KeyUserCredential)
	}
	
	func getCredential() -> String? {
		return UserDefaults.standard.string(forKey: NS2GOConstant.KeyUserCredential)
	}
	
	func getNeighborhood(_ completion: @escaping ([Neighborhood]) -> Void,
						 onError: ((String) -> Void)?) {
		loginService.getNeighborhood { [weak self] (response) in
			let filtered = response.neighborhoods.filter({!$0.ipAddress.isEmpty})
			self?.neighborhood = filtered
			var nodeStatusDict: [String: NodeConnectionStatus] = [:]
			for node in filtered {
				nodeStatusDict[node.sysName] = .connecting
			}
			
			self?.nodeConnectionStatuses = nodeStatusDict
			completion(filtered)
		} onFailed: { (message) in
			onError?(message)
		}
	}
	
	func loginEachNode(shouldRemoveAll: Bool,
					   completion: @escaping () -> Void,
					   onError: ((String) -> Void)?) {
		if shouldRemoveAll {
			nodeAlert.removeAll()
		}
		
		var waitResponseCount = whitelistedNeighborhood.count
		for node in whitelistedNeighborhood {
			guard node.ipAddress != BaseURL.shared.vpnBaseAddress ||
					node.port != BaseURL.shared.vpnBasePort else {
						waitResponseCount -= 1
						if waitResponseCount == 0 {
							completion()
						}
						continue
					}
			
			loginNode(ip: node.ipAddress, port: node.port) { [weak self] in
				waitResponseCount -= 1
				guard waitResponseCount == 0,
					  let self = self else {
					return
				}
				
				self.nodeAlert = self.nodeAlert.filter({$0.alertlimits.count > 0})
				completion()
			} onError: {  [weak self] (message) in
				waitResponseCount -= 1
				guard waitResponseCount == 0,
					  let self = self else {
					return
				}
				
				if self.nodeAlert.count > 0 {
					self.nodeAlert = self.nodeAlert.filter({$0.alertlimits.count > 0})
					completion()
				} else {
					onError?(message)
				}
			}
		}
	}
	
	func loginNode(ip: String?,
				   port: String?,
				   completion: @escaping () -> Void,
				   onError: ((String) -> Void)?) {
		loginService.login(ip: ip, port: port, username: username, password: password) { (nodeAlert) in
			self.nodeAlert.append(nodeAlert)
			completion()
		} onFailed: { (message) in
			if let ip = ip, let port = port {
				let nodeStatus: NodeConnectionStatus = message.contains("timed out") ? .timeOut : .failed
				self.updateNodeConnection(ip: ip, port: port, status: nodeStatus)
			}
			onError?(message)
		}
	}
	
	func fetchAllStatusNode(onComplete: (() -> Void)?,
							onError: ((String) -> Void)?) {
		self.nodeStatuses.removeAll()
		
		var waitResponseCount = whitelistedNeighborhood.count
		var haveSuccess: Bool = false
		
		for node in whitelistedNeighborhood {
			fetchStatusData(
				ip: node.ipAddress,
				port: node.port,
				onComplete: { [weak self] in
					waitResponseCount -= 1
					haveSuccess = true
					guard waitResponseCount == 0 else {
						return
					}
					
					self?.successCompletions.forEach { (completion) in
						completion()
					}
					onComplete?()
			}, onError: { [weak self] message in
				waitResponseCount -= 1
				
				guard waitResponseCount == 0 else {
					return
				}
				
				if haveSuccess {
					onComplete?()
					self?.successCompletions.forEach { (completion) in
						completion()
					}
				} else {
					onError?(message)
					self?.errorCompletions.forEach { (completion) in
						completion(message)
					}
				}
			})
		}
	}
	
	func fetchStatusData(ip: String? = nil, port: String? = nil, onComplete: (() -> Void)?,
						 onError: ((String) -> Void)?) {
		service.getCurrentStatus(
			ip: ip,
			port: port,
			onComplete: { [weak self] _, nodeStatus in
				self?.lastFetchTime = Date()
				
				if let alert = self?.nodeAlert.first(where: {(nodeStatus.nodename?.contains($0.nodename) ?? false) }) {
					nodeStatus.alertLimits = alert.alertlimits
				}
				
				self?.nodeStatuses.append(nodeStatus)
				
				onComplete?()
			}, onFailed: { message in
				if let ip = ip, let port = port {
					let nodeStatus: NodeConnectionStatus = message.contains("timed out") ? .timeOut : .failed
					self.updateNodeConnection(ip: ip, port: port, status: nodeStatus)
				}
				onError?(message)
			})
	}
	
	func getAllVersions(onComplete: (() -> Void)?,
						onError: ((String) -> Void)?) {
		versions.removeAll()
		
		var waitResponseCount = neighborhood.count
		var haveSuccess: Bool = false
		for node in neighborhood {
			getVersion(ip: node.ipAddress, port: node.port) { [weak self] in
				waitResponseCount -= 1
				haveSuccess = true
				if waitResponseCount == 0 {
					self?.filterWhitelist()
					onComplete?()
				}
			} onError: { [weak self] (message) in
				waitResponseCount -= 1
				if waitResponseCount == 0 {
					if haveSuccess {
						self?.filterWhitelist()
						onComplete?()
					} else {
						onError?(message)
					}
				}
			}
		}
	}
	
	func getVersion(ip: String? = nil, port: String? = nil, onComplete: @escaping() -> Void, onError: ((String) -> Void)?) {
		service.getCurrentVersion(ip: ip, port: port) { (version) in
			self.versions.append(version)
			onComplete()
		} onFailed: { (message) in
			if let ip = ip, let port = port {
				let nodeStatus: NodeConnectionStatus = message.contains("timed out") ? .timeOut : .failed
				self.updateNodeConnection(ip: ip, port: port, status: nodeStatus)
			}
			onError?(message)
		}
	}
	
	func filterWhitelist() {
		let filteredVersion = versions.filter({whitelistVersion.contains($0.version)})
		let filteredNodename = filteredVersion.map({$0.systemname})
		
		let whitelistedNode = neighborhood.filter({filteredNodename.contains($0.sysName)})
		let blacklistedNode = neighborhood.filter({!filteredNodename.contains($0.sysName)})
		self.whitelistedNeighborhood = whitelistedNode
		self.nodeAlert = nodeAlert.filter({ (node) -> Bool in
			var nodename = node.nodename
			if !nodename.starts(with: "\\") {
				nodename = "\\\(node.nodename)"
			}
			
			return filteredNodename.contains(nodename)
		})
		self.nodeStatuses = nodeStatuses.filter({filteredNodename.contains($0.nodename ?? "")})
		
		for node in blacklistedNode {
			guard nodeConnectionStatuses.keys.contains(node.sysName),
				  nodeConnectionStatuses[node.sysName] == .connecting else {
				continue
			}
			
			nodeConnectionStatuses[node.sysName] = .blacklist
		}
	}
	
	private func updateNodeConnection(ip: String, port: String, status: NodeConnectionStatus) {
		guard let node = neighborhood.first(where: {$0.ipAddress == ip && $0.port == port}),
			  nodeConnectionStatuses[node.sysName] == .connecting else {
			return
		}
		
		nodeConnectionStatuses[node.sysName] = status
	}
}

enum NodeConnectionStatus: String {
	case connecting = "Connecting"
	case timeOut = "Timed Out"
	case failed = "Failed"
	case blacklist = "Unsupported Version"
	case success = "Success"
}
