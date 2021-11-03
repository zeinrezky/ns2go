//
//  ProcessDetailViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 11/10/21.
//

import UIKit

class ProcessDetailViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet var sectionHeader: UIView!
	
	var instances: [CPUProcessInstance] = []
	
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
		let margin: CGFloat = traitCollection.isDeviceIpad() ? 120 : 40
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		tableView.separatorStyle = .none
		tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
		tableView.register(UINib(nibName: ProcessDetailTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProcessDetailTableViewCell.identifier)
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

extension ProcessDetailViewController: UITableViewDelegate {
	
}

extension ProcessDetailViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return instances.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ProcessDetailTableViewCell.identifier) as? ProcessDetailTableViewCell else {
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
		
		return sectionHeader
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 40.0
	}
}
