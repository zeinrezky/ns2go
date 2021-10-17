//
//  CIPSSRV.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 17/10/21.
//

import Foundation
import SwiftyJSON

class CIPSSRV: BaseInstance {
	let bufferdenials: Double?
	let itapierrors: Double?
	let linuxerrors: Double?
	let bfrbytesincurruse: Double?
	let totalrecvmsgs: Double?
	let totalsendmsgs: Double?
	let totalbytessent: Double?
	let totalbytesrcvd: Double?
	let defrsends: Double?
	let failedcmds: Double?
	let tcplistensktscurr: Double?
	let udpsktscurr: Double?
	let tcpconnectionscurr: Double?

	required init(json: JSON) {
		self.bufferdenials = json["BUFFERDENIALS"].double
		self.itapierrors = json["ITAPIERRORS"].double
		self.linuxerrors = json["LINUXERRORS"].double
		self.bfrbytesincurruse = json["BFRBYTESINCURRUSE"].double
		self.totalrecvmsgs = json["TOTALRECVMSGS"].double
		self.totalsendmsgs = json["TOTALSENDMSGS"].double
		self.totalbytessent = json["TOTALBYTESSENT"].double
		self.totalbytesrcvd = json["TOTALBYTESRCVD"].double
		self.defrsends = json["DEFRSENDS"].double
		self.failedcmds = json["FAILEDCMDS"].double
		self.tcplistensktscurr = json["TCPLISTENSKTSCURR"].double
		self.udpsktscurr = json["UDPSKTSCURR"].double
		self.tcpconnectionscurr = json["TCPCONNECTIONSCURR"].double
		
		super.init(json: json)
	}
}
