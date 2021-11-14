//
//  NeighborhoodResponse.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 14/11/21.
//

import Foundation
import SwiftyJSON

class NeighborhoodResponse {
	let status: String
	let message: String?
	let operationType: String
	let neighborhoods: [Neighborhood]
	
	init(json: JSON) {
		self.status = json["status"].stringValue
		self.message = json["message"].string
		self.operationType = json["operationtype"].stringValue
		
		var neighborhoods: [Neighborhood] = []
		
		if let array = json["neigbhordetail"].array {
			for jsonObject in array {
				let object = Neighborhood(json: jsonObject)
				neighborhoods.append(object)
			}
		}
		
		self.neighborhoods = neighborhoods
	}
}

class Neighborhood {
	let sysName: String
	let env: String?
	let ipAddress: String
	let port: String
	let adminPort: String?
	
	init(json: JSON) {
		self.sysName = json["SysName"].stringValue
		self.env = json["Env"].string
		self.ipAddress = json["IP"].stringValue
		self.port = json["Port"].stringValue
		self.adminPort = json["AdminPort"].string
	}
}
