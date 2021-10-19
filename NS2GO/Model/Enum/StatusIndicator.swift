//
//  StatusIndicator.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 19/10/21.
//

import Foundation
import UIKit

enum StatusIndicator: Int {
	case clear = 0
	case green = 1
	case yellow = 2
	case red = 3
	
	var color: UIColor {
		switch self {
		case .clear:
			return UIColor.clear
		case .green:
			return AppColor.indicatorGreen
		case .yellow:
			return AppColor.indicatorYellow
		case .red:
			return AppColor.indicatorRed
		}
	}
	
	func compareHigher(indicator: StatusIndicator) -> StatusIndicator {
		return self.rawValue < indicator.rawValue ? indicator : self
	}
}
