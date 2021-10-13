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
	
	func configureCell(cellType: CellType) {
		containerView.backgroundColor = cellType.color
		nodeLabel.text = cellType.rawValue
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
		
		var color: UIColor {
			switch self {
			case .cpu:
				return UIColor(red: 250.0/255.0, green: 244.0/255.0, blue: 104.0/255.0, alpha: 1)
			case .ipu:
				return UIColor(red: 174.0/255.0, green: 252.0/255.0, blue: 194.0/255.0, alpha: 1)
			case .disk:
				return UIColor(red: 174.0/255.0, green: 252.0/255.0, blue: 194.0/255.0, alpha: 1)
			case .process:
				return UIColor(red: 253.0/255.0, green: 165.0/255.0, blue: 154.0/255.0, alpha: 1)
			}
		}
		
	}
}
