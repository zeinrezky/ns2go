//
//  VPNManager.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 16/10/21.
//

import Foundation
//import OpenSSL
import NetworkExtension
import KeychainAccess

class VPNManager {
	static let shared = VPNManager()
	
	private let manager = NEVPNManager.shared()
	private let keychain = Keychain(service: "com.mrhoo.NS2GO")
	var ipAddress: String? = BaseURL.vpnBaseAddress
	var port: String? = BaseURL.vpnBasePort
	var username: String = "bubbl3"
	var password: String = "Welcome@G-pit.Hub192"
	
	init() {
		do {
			try keychain.set(password, key: "vpn_password")
		} catch {
			print(error.localizedDescription)
		}
		
		setupLoadPreferences()
	}
	
	func setupLoadPreferences() {
		manager.loadFromPreferences { [weak self] (error) in
			if (error != nil) {
				print(error?.localizedDescription)
			} else {
				do{
					try self?.manager.connection.startVPNTunnel()
				} catch {
					print(error.localizedDescription)
				}
			}
		}
	}
	
	func connectToVPN() {
		guard let ipAddress = ipAddress,
			  let port = port else {
			return
		}
		let vpnProtocol = NEVPNProtocolIKEv2()
		vpnProtocol.authenticationMethod = .none
		vpnProtocol.serverAddress = ipAddress + ":" + port
		vpnProtocol.username = username
		do {
			try vpnProtocol.passwordReference = keychain.getData("vpn_password")
		} catch {
			print(error.localizedDescription)
		}
		
		manager.protocolConfiguration = vpnProtocol
		manager.isOnDemandEnabled = true
		manager.isEnabled = true
		
		manager.saveToPreferences { [weak self] (error) in
			if let error = error {
				print(error.localizedDescription)
			} else {
				self?.setupLoadPreferences()
			}
		}
	}
}
