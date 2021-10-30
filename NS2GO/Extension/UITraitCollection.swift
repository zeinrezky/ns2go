//
//  UITraitCollection.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 31/10/21.
//

import Foundation
import UIKit

extension UITraitCollection {
	
	func isDeviceIpad() -> Bool {
		return horizontalSizeClass == .regular && verticalSizeClass == .regular
	}
}
