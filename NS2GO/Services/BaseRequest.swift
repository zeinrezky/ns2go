//
//  BaseRequest.swift
//  Tambo
//
//  Created by Yosua Hoo on 05/09/19.
//  Copyright © 2019 Yosua Hoo. All rights reserved.
//

import Foundation
import Alamofire

class BaseRequest {
    
    static func getDefaultHeader() -> HTTPHeaders {
        
        let header = [
            "Accept" : "application/json",
            "Content-Type":"application/x-www-form-urlencoded"
        ]
		
		return HTTPHeaders(header)
    }
    
    static func GET(url:String,
                    header:HTTPHeaders,
                    parameter:Parameters? = nil,
                    success: @escaping (Any) -> Void,
                    failure: @escaping (String) -> Void) {
        
        print("DEBUG - URL : \(url)")
        print("DEBUG - HEADER : \(header)")
		print("DEBUG - PARAMETER : \(String(describing: parameter))")
        
        if let encodedString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            let url = URL(string: encodedString) {
            
			AF.session.configuration.timeoutIntervalForRequest = 30
            AF.session.configuration.timeoutIntervalForResource = 30
			
            AF.request(
                url,
                method: .get,
                parameters: parameter,
                encoding : URLEncoding.default,
                headers: header
            ).responseJSON{ (response) in
                
                print("DEBUG - RESPONSE : \(response)")
				
				if let value = response.value {
					success(value)
				} else {
					failure(response.error?.localizedDescription ?? "")
				}
				
            }.validate(statusCode: 200..<300)
        }
    }
    
    static func POST(url:String, parameter:Parameters, header:HTTPHeaders, success: @escaping (Any) -> Void, failure: @escaping (String) -> Void) {
        
        print("DEBUG - URL : \(url)")
        print("DEBUG - HEADER : \(header)")
        print("DEBUG - PARAMETER : \(parameter)")
        
        if let encodedString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            let url = URL(string: encodedString) {
            
			AF.session.configuration.timeoutIntervalForRequest = 30
			AF.session.configuration.timeoutIntervalForResource = 30
            
            AF.request(
                url,
                method: .post,
                parameters: parameter,
                encoding: URLEncoding.httpBody,
                headers: header
            ).responseJSON { (response) in
                print("DEBUG - RESPONSE : \(response)")
                
				if let value = response.value {
					success(value)
				} else {
					failure(response.error?.localizedDescription ?? "")
				}
				
            }.validate(statusCode: 200..<300)
        }
    }
}
