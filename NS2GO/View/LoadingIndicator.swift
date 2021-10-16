//
//  LoadingIndicator.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 15/10/21.
//

import Foundation
import UIKit

class LoadingIndicator: UIView {
	
	static let shared = LoadingIndicator()
	let indicator = UIActivityIndicatorView()
	
	init() {
		super.init(frame: .zero)
		setupIndicator()
		self.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
		self.isUserInteractionEnabled = true
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	private func setupIndicator() {
		indicator.color = .white
		indicator.startAnimating()
		
		if #available(iOS 13.0, *) {
			indicator.style = .large
		} else {
			indicator.style = .whiteLarge
		}
		
		indicator.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
		self.addSubview(indicator)
	}
	
}
