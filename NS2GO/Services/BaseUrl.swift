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
		vpnBaseAddress = UserDefaults.standard.string(forKey: NS2GOConstant.KeyServerAddress)
		vpnBasePort = UserDefaults.standard.string(forKey: NS2GOConstant.KeyServerPort)
	}
	
	func saveIPServer() {
		UserDefaults.standard.setValue(vpnBaseAddress, forKey: NS2GOConstant.KeyServerAddress)
		UserDefaults.standard.setValue(vpnBasePort, forKey: NS2GOConstant.KeyServerPort)
		
		BaseRequest.shared.setupSession()
	}
}
