//
//  IPUDetailViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 11/10/21.
//

import UIKit

class IPUDetailViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	var instances: [CPUProcessInstance] = []
	
	var alert: [AlertLimit] = []
	var navTitle: String = "IPU"
	
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
		self.title = navTitle
	}
	
	private func setupTableView() {
		let margin: CGFloat = traitCollection.isDeviceIpad() ? 120 : 60
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		tableView.separatorInset = UIEdgeInsets(top: 1, left: margin, bottom: 1, right: margin)
		tableView.separatorColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1)
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
		nameLabel.textAlignment = .center
		
		let busyLabel = UILabel()
		busyLabel.text = "Busy %"
		busyLabel.textColor = textColor
		busyLabel.font = font
		busyLabel.textAlignment = .center
		
		let lenghtLabel = UILabel()
		lenghtLabel.text = "Q. Length"
		lenghtLabel.textColor = textColor
		lenghtLabel.font = font
		lenghtLabel.textAlignment = .center
		
		let margin: CGFloat = traitCollection.isDeviceIpad() ? 120 : 60
		
		let stack = UIStackView(arrangedSubviews: [nameLabel, busyLabel, lenghtLabel])
		stack.frame = CGRect(x: margin, y: 0, width: tableView.frame.width - (2 * margin), height: 40)
		stack.axis = .horizontal
		stack.distribution = .fillEqually
		
		let separator = UIView(frame: CGRect(x: margin, y: 39, width: tableView.frame.width - (2 * margin), height: 1))
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
		
		let margin: CGFloat = traitCollection.isDeviceIpad() ? 120 : 60
		
		let stack = UIStackView(arrangedSubviews: [nameLabel])
		stack.frame = CGRect(x: margin, y: 0, width: tableView.frame.width - (2 * margin), height: 40)
		stack.axis = .horizontal
		stack.distribution = .fillEqually
		
		view.addSubview(stack)
		
		return view
	}
}

extension IPUDetailViewController: UITableViewDelegate {
	
}

extension IPUDetailViewController: UITableViewDataSource {
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return instances.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: StatusDetailTableViewCell.identifier) as? StatusDetailTableViewCell else {
			return UITableViewCell()
		}
		
		let instance = instances[indexPath.item]
		cell.configureCell(alertLimits: alert, cpuInstance: instance)
		
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
