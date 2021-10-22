//
//  ResponseDetailViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 22/10/21.
//

import UIKit

class ResponseDetailViewController: UIViewController {
	
	@IBOutlet weak var textView: UITextView!
	
	var response: [String: Any]? = [:]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		guard let response = response else {
			textView.text = "\(self.response ?? [:])"
			return
		}
		
		do {
			let json = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
			let stringJSON = String(data: json, encoding: .utf8)
			textView.text = stringJSON
		} catch {
			print(error.localizedDescription)
		}
		
		
    }
}
