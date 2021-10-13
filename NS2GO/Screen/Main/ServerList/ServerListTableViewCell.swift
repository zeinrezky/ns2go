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
	@IBOutlet weak var serverNameLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		setupContainerView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
