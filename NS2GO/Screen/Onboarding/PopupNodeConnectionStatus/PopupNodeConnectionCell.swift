//
//  PopupNodeConnectionCell.swift
//  NS2GO
//
//  Created by Yosua Hoo on 14/12/21.
//

import UIKit

class PopupNodeConnectionCell: UITableViewCell {
	
	static let identifier = "PopupNodeConnectionCell"

	@IBOutlet weak var lbNodeName: UILabel!
	@IBOutlet weak var lbStatuses: UILabel!
	@IBOutlet weak var viewIndicator: UIView!
	@IBOutlet weak var viewIndicatorContainer: UIView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		viewIndicator.layer.cornerRadius = viewIndicator.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func configureCell(nodename: String, status: NodeConnectionStatus) {
		lbNodeName.text = nodename
		lbStatuses.text = status.rawValue
		
		switch status {
		case .connecting:
			viewIndicatorContainer.isHidden = true
			viewIndicator.isHidden = true
			activityIndicator.isHidden = false
			activityIndicator.startAnimating()
		case .success:
			viewIndicatorContainer.isHidden = false
			viewIndicator.isHidden = false
			viewIndicator.backgroundColor = AppColor.indicatorGreen
			activityIndicator.isHidden = true
		case .blacklist, .failed, .timeOut:
			viewIndicatorContainer.isHidden = false
			viewIndicator.isHidden = false
			viewIndicator.backgroundColor = AppColor.indicatorRed
			activityIndicator.isHidden = true
		}
	}
    
}
