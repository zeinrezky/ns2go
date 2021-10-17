//
//  BaseUrl.swift
//  Tambo
//
//  Created by Yosua Hoo on 16/05/20.
//  Copyright © 2020 MisterHoo. All rights reserved.
//

import Foundation
import KeychainAccess

class BaseURL {
	static let shared = BaseURL()
	
	let guestBaseURL = "https://studio.hpremoteanalyst.com/api/ns2go/"
	var vpnBaseURL: String{
		return "https://\(vpnBaseAddress ?? ""):\(vpnBasePort ?? "")/"
	}
	
	var vpnBaseAddress: String?
	var vpnBasePort: String?
	
	var isHaveServerPreferences: Bool {
		return !(vpnBaseAddress ?? "").isEmpty && !(vpnBasePort ?? "").isEmpty
	}
	
	let keychain = Keychain(service: NS2GOConstant.keychainIdentifier)
	
	func loadIPServer() {
		do {
			try vpnBaseAddress = keychain.get(NS2GOConstant.KeyServerAddress)
			try vpnBasePort = keychain.get(NS2GOConstant.KeyServerPort)
		} catch {
			print(error.localizedDescription)
		}
	}
	
	func saveIPServer() {
		guard let ipAddress = vpnBaseAddress,
			  let port = vpnBasePort else {
			return
		}
		
		do {
			try keychain.set(ipAddress, key: NS2GOConstant.KeyServerAddress)
			try keychain.set(port, key: NS2GOConstant.KeyServerPort)
		} catch {
			print(error.localizedDescription)
		}
		
		BaseRequest.shared.setupSession()
	}
}
