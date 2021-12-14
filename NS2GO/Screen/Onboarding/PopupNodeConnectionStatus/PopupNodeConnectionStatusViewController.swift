//
//  PopupNodeConnectionStatusViewController.swift
//  NS2GO
//
//  Created by Yosua Hoo on 14/12/21.
//

import UIKit

class PopupNodeConnectionStatusViewController: UIViewController {
	var onTapContinue: (() -> Void)?
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var btContinue: UIButton!
	@IBOutlet weak var constHeightTable: NSLayoutConstraint!
	@IBOutlet weak var containerView: UIView!
	
	private var nodeConnectionStatuses: [String: NodeConnectionStatus] {
		return ServiceHelper.shared.nodeConnectionStatuses
	}
	
	private var nodenames: [String] {
		return nodeConnectionStatuses.map({$0.key})
	}
	
	private var isCanContinue: Bool = false {
		didSet {
			let disableColor = UIColor.lightGray.withAlphaComponent(0.5)
			let enableColor = UIColor(red: 75.0/255.0, green: 114.0/255.0, blue: 204.0/255.0, alpha: 1)
			
			btContinue.isEnabled = isCanContinue
			btContinue.backgroundColor = isCanContinue ? enableColor : disableColor
		}
	}
	
	@IBAction func didTapContinue(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
		self.onTapContinue?()
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupTableView()
		containerView.layer.cornerRadius = 4
		btContinue.layer.cornerRadius = 4
		isCanContinue = false
		
		ServiceHelper.shared.onChangeConnectionStatus = { [weak self] in
			DispatchQueue.main.async {
				self?.tableView.reloadData()
			}
			
			let isCanContinue = self?.nodeConnectionStatuses.allSatisfy({$0.value != .connecting})
			self?.isCanContinue = isCanContinue ?? false
		}
    }
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		guard keyPath == #keyPath(UITableView.contentSize),
			  let newSize = change?[.newKey] as? CGSize else {
			return
		}
		
		let maximumSize:CGFloat = 440
		let height = min(maximumSize, newSize.height)
		constHeightTable.constant = height
		self.view.setNeedsLayout()
		self.view.layoutIfNeeded()
	}

	private func setupTableView() {
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		tableView.allowsSelection = false
		tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		tableView.register(UINib(nibName: PopupNodeConnectionCell.identifier, bundle: nil), forCellReuseIdentifier: PopupNodeConnectionCell.identifier)
		
		tableView.addObserver(self, forKeyPath: #keyPath(UITableView.contentSize), options: .new, context: nil)
	}

}

extension PopupNodeConnectionStatusViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return nodenames.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: PopupNodeConnectionCell.identifier, for: indexPath) as? PopupNodeConnectionCell else {
			return UITableViewCell()
		}
		
		let nodename = nodenames[indexPath.item]
		cell.configureCell(nodename: nodename, status: nodeConnectionStatuses[nodename] ?? .failed)
		
		return cell
	}
}
