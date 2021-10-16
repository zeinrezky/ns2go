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
	
	private static let vpnBaseAddressKey = "vpnIPAddress"
	private static let vpnBasePortKey = "vpnPort"
	
	let guestBaseURL = "https://studio.hpremoteanalyst.com/api/ns2go/"
	var vpnBaseURL: String{
		return "https://\(vpnBaseAddress ?? ""):\(vpnBasePort ?? "")/"
	}
	
	var vpnBaseAddress: String?
	var vpnBasePort: String?
	
	var isHaveServerPreferences: Bool {
		return !(vpnBaseAddress ?? "").isEmpty && !(vpnBasePort ?? "").isEmpty
	}
	
	let keychain = Keychain(service: "com.NS2GO")
	
	func loadIPServer() {
		do {
			try vpnBaseAddress = keychain.get(BaseURL.vpnBaseAddressKey)
			try vpnBasePort = keychain.get(BaseURL.vpnBasePortKey)
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
			try keychain.set(ipAddress, key: BaseURL.vpnBaseAddressKey)
			try keychain.set(port, key: BaseURL.vpnBasePortKey)
		} catch {
			print(error.localizedDescription)
		}
	}
}
