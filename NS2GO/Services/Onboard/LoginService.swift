//
//  LoginService.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 16/10/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class LoginService {
	
	func login(ip: String?,
			   port: String?,
			   username: String,
			   password: String,
			   onComplete : @escaping(Node) -> Void,
			   onFailed : ((String) -> Void)?) {
		
		var baseUrl = BaseURL.shared.vpnBaseURL
		
		if let ip = ip,
		   let port = port {
			baseUrl = "https://\(ip):\(port)/"
		}
		
		let url = baseUrl + "homepage"
		
		let logonInfo = password + ";" + username
		let hexLogonInfo = "V" + logonInfo.hexString()
		
		let parameter: [String: Any] = [
			"requestor" : "WVP",
			"command" : "DO_LOGON",
			"LOGONINFO" : hexLogonInfo,
			"lite" : 0
		]
		
		let header: HTTPHeaders = BaseRequest.shared.getDefaultHeader()
		
		BaseRequest.shared.POST(url: url, parameter: parameter, header: header, success: { (data) in
			
			let json = JSON(data)
			let node = Node(json: json)
			
			if let errorMessage = node.errorMessage,
			   errorMessage == "48"{
				onFailed?("Invalid Logon")
				return
			}
			
			onComplete(node)
			
		}) { (message) in
			onFailed?(message)
		}
	}
	
	func getNeighborhood(onComplete : @escaping(NeighborhoodResponse) -> Void,
						 onFailed : ((String) -> Void)?) {
		let url = BaseURL.shared.vpnBaseURL + "homepage"
		
		let parameter: [String: Any] = [
			"requestor" : "WVP",
			"command" : "GET_NEIGHBORHOODS",
			"CRINFO" : "",
			"LITE" : 0
		]
		
		let header: HTTPHeaders = BaseRequest.shared.getDefaultHeader()
		
		BaseRequest.shared.GETVPN(url: url, header: header, parameter: parameter, success: { (data) in
			
			let json = JSON(data)
			let object = NeighborhoodResponse(json: json)
			onComplete(object)
			
		}) { (message) in
			onFailed?(message)
		}
	}
	
}
