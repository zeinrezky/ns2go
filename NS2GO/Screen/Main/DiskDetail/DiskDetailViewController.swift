//
//  DiskDetailViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 11/10/21.
//

import UIKit

class DiskDetailViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	var instances: [DiskProcessInstance] = []
	
	var alert: [AlertLimit] = []
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupTableView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationBar()
	}
 
	private func setupNavigationBar() {
		self.setupDefaultNavigationBar()
	}
	
	private func setupTableView() {
		let margin: CGFloat = traitCollection.isDeviceIpad() ? 120 : 60
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		tableView.separatorStyle = .none
		tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
		tableView.register(UINib(nibName: StatusDetailTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: StatusDetailTableViewCell.identifier)
	}
	
	private func createSectionHeader() -> UIView {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
		view.backgroundColor = .white
		
		let textColor = UIColor(red: 61.0/255.0, green: 61.0/255.0, blue: 61.0/255.0, alpha: 1)
		let font = UIFont(name: "HelveticaNeue", size: 12)
		
		let nameLabel = UILabel()
		nameLabel.text = "Name"
		nameLabel.textColor = textColor
		nameLabel.font = font
		nameLabel.textAlignment = .left
		
		let busyLabel = UILabel()
		busyLabel.text = "DP2 Busy %"
		busyLabel.textColor = textColor
		busyLabel.font = font
		busyLabel.textAlignment = .right
		
		let lenghtLabel = UILabel()
		lenghtLabel.text = "Q. Length"
		lenghtLabel.textColor = textColor
		lenghtLabel.font = font
		lenghtLabel.textAlignment = .right
		
		let margin: CGFloat = traitCollection.isDeviceIpad() ? 120 : 40
		let separatorMargin: CGFloat = 10
		
		let stack = UIStackView(arrangedSubviews: [nameLabel, busyLabel, lenghtLabel])
		stack.frame = CGRect(x: margin, y: 0, width: tableView.frame.width - (2 * margin), height: 40)
		stack.axis = .horizontal
		stack.distribution = .fillEqually
		
		let separator = UIView(frame: CGRect(x: margin - separatorMargin, y: 39, width: tableView.frame.width - (2 * (margin - separatorMargin)) , height: 1))
		separator.backgroundColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1)
		
		view.addSubview(stack)
		view.addSubview(separator)
		
		return view
	}
	
	private func createNoDataAvailable() -> UIView {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
		view.backgroundColor = .white
		
		let textColor = UIColor(red: 61.0/255.0, green: 61.0/255.0, blue: 61.0/255.0, alpha: 1)
		let font = UIFont(name: "HelveticaNeue", size: 12)
		
		let nameLabel = UILabel()
		nameLabel.text = "No data available"
		nameLabel.textColor = textColor
		nameLabel.font = font
		nameLabel.textAlignment = .center
		
		let margin: CGFloat = traitCollection.isDeviceIpad() ? 120 : 40
		
		let stack = UIStackView(arrangedSubviews: [nameLabel])
		stack.frame = CGRect(x: margin, y: 0, width: tableView.frame.width - (2 * margin), height: 40)
		stack.axis = .horizontal
		stack.distribution = .fillEqually
		
		view.addSubview(stack)
		
		return view
	}
}

extension DiskDetailViewController: UITableViewDelegate {
	
}

extension DiskDetailViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return instances.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: StatusDetailTableViewCell.identifier) as? StatusDetailTableViewCell else {
			return UITableViewCell()
		}
		let instance = instances[indexPath.item]
		cell.configureCell(alertLimits: alert, diskInstance: instance)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if instances.count == 0 {
			return createNoDataAvailable()
		}
		
		return createSectionHeader()
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 40.0
	}
}
