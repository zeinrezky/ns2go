//
//  NodeTableViewCell.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 10/10/21.
//

import UIKit

class NodeTableViewCell: UITableViewCell {

	static let identifier = "NodeTableViewCell"
	
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var nodeLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		setupContainerView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func configureCell(cellType: CellType, objects: [ObjectMonitored], nodeAlert: [AlertLimit]) {
		nodeLabel.text = cellType.rawValue
		
		var indicator: StatusIndicator = .green
		if cellType == .cpu,
		   let object = objects.first {
			let objecIndicator = object.getIndicator(alertLimits: nodeAlert)
			indicator = indicator.compareHigher(indicator: objecIndicator)
		} else if cellType == .ipu,
				  let object = objects.first {
			let objecIndicator = object.getIndicator(alertLimits: nodeAlert)
			indicator = indicator.compareHigher(indicator: objecIndicator)
		} else {
			objects.forEach { (object) in
				let objecIndicator = object.getIndicator(alertLimits: nodeAlert)
				indicator = indicator.compareHigher(indicator: objecIndicator)
			}
		}
		
		containerView.backgroundColor = indicator.color
	}
	
	private func setupContainerView() {
		containerView.backgroundColor = .cyan
		containerView.layer.cornerRadius = 20.0
		containerView.layer.shadowColor = UIColor.black.cgColor
		containerView.layer.shadowOffset = CGSize(width: 10, height: 10)
		containerView.layer.shadowRadius = 2.0
		containerView.layer.shadowOpacity = 0.1
		containerView.layer.shouldRasterize = true
		containerView.layer.rasterizationScale = UIScreen.main.scale
		containerView.layer.masksToBounds = false
		containerView.clipsToBounds = false
	}
}

extension NodeTableViewCell {
	enum CellType: String {
		case cpu = "CPU"
		case ipu = "IPU"
		case disk = "DISK"
		case process = "PROCESS"
	}
}
