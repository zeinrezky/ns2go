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
	
	func login(username: String,
			   password: String,
			   onComplete : @escaping([String: Any]?,[Node]) -> Void,
			   onFailed : ((String) -> Void)?) {
		
		let url = BaseURL.shared.vpnBaseURL + "homepage"
		
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
			var dict = json.dictionaryObject
			dict?["response_name"] = "Alert Limits"
			onComplete(dict, [node])
			
		}) { (message) in
			onFailed?(message)
		}
	}
	
}
