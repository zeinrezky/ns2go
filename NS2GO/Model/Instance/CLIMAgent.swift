//
//  CLIMAgent.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 17/10/21.
//

import Foundation
import SwiftyJSON

class CLIMAgent: BaseInstance {
	let bufferDenials: String?
	let itapiErrors: String?
	let linuxErrors: String?
	let bfrbytesincurruse: String?
	let messagesReceived: String?
	let messagesSent: String?
	let queuedCommands: String?
	let failedCommands: String?
	
	required init(json: JSON) {
		self.bufferDenials = json["BUFFERDENIALS"].string
		self.itapiErrors = json["ITAPIERRORS"].string
		self.linuxErrors = json["LINUXERRORS"].string
		self.bfrbytesincurruse = json["BFRBYTESINCURRUSE"].string
		self.messagesReceived = json["Messages Received"].string
		self.messagesSent = json["Messages Sent"].string
		self.queuedCommands = json["Queued Commands"].string
		self.failedCommands = json["Failed Commands"].string
		
		super.init(json: json)
	}

}
