//
//  BaseInstance.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 17/10/21.
//

import Foundation
import SwiftyJSON

class BaseInstance {
	let ts: String?
	let name: String?
	
	required init(json: JSON) {
		self.ts = json["TS"].string
		self.name = json["name"].string ?? String(json["name"].intValue)
	}
}
