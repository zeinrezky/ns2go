//
//  DashboardService.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 17/10/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class DashboardService {
	func getCurrentStatus(ip: String?,
						  port: String?,
						  onComplete : @escaping([String: Any]?, NodeStatus) -> Void,
						  onFailed : ((String) -> Void)?) {
		var baseUrl = BaseURL.shared.vpnBaseURL
		
		if let ip = ip,
		   let port = port {
			baseUrl = "https://\(ip):\(port)/"
		}
		
		let url = baseUrl + "homepage"
		
		let parameter: [String: Any] = [
			"requestor" : "XVIEW",
			"command" : "GET_XVIEW_DATA",
			"producer_name" : "IDELJI",
			"product_name" : "Web ViewPoint Enterprise",
			"product_version" : "L01AAR",
			"entity" : "CLIM",
			"request_type" : "C"
		]
		
		let header: HTTPHeaders = BaseRequest.shared.getDefaultHeader()
		
		BaseRequest.shared.POST(url: url, parameter: parameter, header: header, success: { (data) in
			
			let json = JSON(data)
			let nodeStatus = NodeStatus(json: json)
			var dict = json.dictionaryObject
			dict?["response_name"] = "Get XView Data"
			onComplete(dict, nodeStatus)
			
		}) { (message) in
			onFailed?(message)
		}
	}
	
	func getCurrentVersion(ip: String?,
						   port: String?,
						   onComplete: @escaping (Version) -> Void,
						   onFailed: ((String) -> Void)?) {
		
		var baseUrl = BaseURL.shared.vpnBaseURL
		
		if let ip = ip,
		   let port = port {
			baseUrl = "https://\(ip):\(port)/"
		}
		
		let url = baseUrl + "homepage"
		let parameter: [String: Any] = [
			"command" : "GET_VERSION_INFO"
		]
		
		let header: HTTPHeaders = BaseRequest.shared.getDefaultHeader()
		
		BaseRequest.shared.GETVPN(url: url, header: header, parameter: parameter, success: { (data) in
			
			let json = JSON(data)
			let version = Version(json: json)
			onComplete(version)
			
		}) { (message) in
			onFailed?(message)
		}
	}
}
