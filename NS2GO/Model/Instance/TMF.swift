//
//  TMF.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 17/10/21.
//

import Foundation
import SwiftyJSON

class TMF: BaseInstance {
	let tps: Int?
	
	required init(json: JSON) {
		self.tps = json["TPS"].int
		
		super.init(json: json)
	}

}
