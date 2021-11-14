//
//  Version.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 14/11/21.
//

import Foundation
import SwiftyJSON

class Version {
	let systemname: String
	let version: String
	
	init(json: JSON) {
		self.systemname = json["systemname"].stringValue
		self.version = json["version"].stringValue
	}
}
