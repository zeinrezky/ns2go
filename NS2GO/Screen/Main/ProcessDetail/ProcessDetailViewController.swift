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
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		tableView.separatorInset = UIEdgeInsets(top: 1, left: 40, bottom: 1, right: 40)
		tableView.separatorColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1)
		tableView.register(UINib(nibName: ProcessDetailTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProcessDetailTableViewCell.identifier)
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
		return sectionHeader
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 40.0
	}
}
