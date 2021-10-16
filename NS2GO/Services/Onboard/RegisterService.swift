//
//  RegisterService.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 15/10/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class RegisterService {
	
	func register(firstName: String,
				  lastName: String,
				  email: String,
				  companyName: String,
				  companyCountry: String,
				  companyState: String,
				  onComplete : @escaping() -> Void,
				  onFailed : ((String) -> Void)?) {
		
		let url = BaseURL.shared.guestBaseURL + "register-user"
		
		let parameter = [
			"first_name" : firstName,
			"last_name" : lastName,
			"email_address" : email,
			"company_name" : companyName,
			"company_country" : companyCountry,
			"company_state" : companyState
		]
		
		let header: HTTPHeaders = BaseRequest.getDefaultHeader()
		
		BaseRequest.POST(url: url, parameter: parameter, header: header, success: { (data) in
			
			let json = JSON(data)
			
			if let jsonError = json["message"].string {
				onFailed?(jsonError)
				return
			}
			
			onComplete()
		}) { (message) in
			onFailed?(message)
		}
	}
	
	func validate(email: String,
				  code: String,
				  onComplete : @escaping() -> Void,
				  onFailed : ((String) -> Void)?) {
		
		let url = BaseURL.shared.guestBaseURL + "validate-user"
		
		let parameter = [
			"email_address" : email,
			"validation_code" : code
		]
		
		let header: HTTPHeaders = BaseRequest.getDefaultHeader()
		
		BaseRequest.POST(url: url, parameter: parameter, header: header, success: { (data) in
			
			let json = JSON(data)
			
			if let status = json["status"].string,
			   status == "OK" {
				onComplete()
				return
			}
			
			if let message = json["message"].string {
				onFailed?(message)
				return
			}
			
			onComplete()
		}) { (message) in
			onFailed?(message)
		}
	}
	
	func resendCode(email: String,
				  onComplete : @escaping() -> Void,
				  onFailed : ((String) -> Void)?) {
		
		let url = BaseURL.shared.guestBaseURL + "resend-code"
		
		let parameter = [
			"email_address" : email
		]
		
		let header: HTTPHeaders = BaseRequest.getDefaultHeader()
		
		BaseRequest.POST(url: url, parameter: parameter, header: header, success: { (data) in
			
			let json = JSON(data)
			
			if let jsonError = json["message"].string {
				onFailed?(jsonError)
				return
			}
			
			onComplete()
		}) { (message) in
			onFailed?(message)
		}
	}
	
}
