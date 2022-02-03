//
//  ServerListTableViewCell.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 10/10/21.
//

import UIKit

class ServerListTableViewCell: UITableViewCell {
	
	static let identifier = "ServerListTableViewCell"
	
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var iconRightArrow: UIImageView!
	@IBOutlet weak var serverNameLabel: UILabel!
	@IBOutlet weak var noAccessLabel: UILabel!
	
	
	var nodename: String = ""
	
    override func awakeFromNib() {
        super.awakeFromNib()
		setupContainerView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func configureCell(neighborhood: Neighborhood) {
		self.nodename = neighborhood.sysName
		let fontColor = UIColor(red: 131.0/255.0, green: 131.0/255.0, blue: 131.0/255.0, alpha: 1)
		serverNameLabel.text = neighborhood.sysName
		serverNameLabel.textColor = fontColor
		
		containerView.backgroundColor = UIColor.white
		containerView.layer.shadowOpacity = 0
		containerView.layer.borderColor = UIColor.lightGray.cgColor
		containerView.layer.borderWidth = 1
		
		iconRightArrow.isHidden = true
		noAccessLabel.isHidden = false
	}
	
	func configureCell(node: NodeStatus) {
		self.nodename = node.nodename ?? ""
		containerView.layer.shadowOpacity = 0.1
		containerView.layer.borderWidth = 0
		serverNameLabel.text = node.nodename
		iconRightArrow.isHidden = false
		noAccessLabel.isHidden = true
		
		if node.indicator == .red {
			containerView.backgroundColor = AppColor.darkRed
			serverNameLabel.textColor = .white
			iconRightArrow.image = UIImage(named: "ic_rightArrowWhite")
		} else {
			let fontColor = UIColor(red: 131.0/255.0, green: 131.0/255.0, blue: 131.0/255.0, alpha: 1)
			serverNameLabel.textColor = fontColor
			iconRightArrow.image = UIImage(named: "ic_rightArrow")
			containerView.backgroundColor = node.indicator.color
		}
	}
    
	private func setupContainerView() {
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
