//
//  NodeViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 10/10/21.
//

import UIKit

class NodeViewController: UIViewController {

	
	@IBOutlet weak var lastSyncLabel: UILabel!
	@IBOutlet var headerView: UIView!
	@IBOutlet weak var tableView: UITableView!
	
	private let cells: [NodeTableViewCell.CellType] = [.cpu, .ipu, .disk, .process]
	
	var nodeStatus: NodeStatus?
	var nodeAlert: Node?
	
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
		self.title = nodeStatus?.nodename
	}
	
	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		tableView.tableHeaderView = headerView
		tableView.separatorStyle = .none
		tableView.register(UINib(nibName: NodeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NodeTableViewCell.identifier)
	}
	
	private func pushToCPUList() {
		let controller = CPUListViewController()
		let cpu = nodeStatus?.monitors.first(where: {$0.category == .CPU})
		let busy = nodeStatus?.monitors.first(where: {$0.category == .Busy})
		let qLength = nodeStatus?.monitors.first(where: {$0.category == .QueueLength})
		controller.cpu = cpu
		controller.busy = busy
		controller.qLength = qLength
		if let alertLimit = nodeAlert?.alertlimits.filter({ (limit) -> Bool in
			return limit.object == .CPU &&
				limit.entity == .busy ||
				limit.entity == .queueLength
		}) {
			controller.alert = alertLimit
		}
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	private func pushToIPUList() {
		let controller = IPUListViewController()
		let cpu = nodeStatus?.monitors.first(where: {$0.category == .CPU})
		let busy = nodeStatus?.monitors.first(where: {$0.category == .Busy})
		let qLength = nodeStatus?.monitors.first(where: {$0.category == .QueueLength})
		controller.cpu = cpu
		controller.busy = busy
		controller.qLength = qLength
		if let alertLimit = nodeAlert?.alertlimits.filter({ (limit) -> Bool in
			return limit.object == .IPU &&
				limit.entity == .busy ||
				limit.entity == .queueLength
		}) {
			controller.alert = alertLimit
		}
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	private func pushToDiskList() {
		let controller = DiskListViewController()
		let busy = nodeStatus?.monitors.first(where: {$0.category == .DiskBusy})
		let qLength = nodeStatus?.monitors.first(where: {$0.category == .DiskQueueLength})
		controller.busy = busy
		controller.qLength = qLength
		if let alertLimit = nodeAlert?.alertlimits.filter({ (limit) -> Bool in
			return limit.object == .Disk &&
				limit.entity == .busy ||
				limit.entity == .queueLength
		}) {
			controller.alert = alertLimit
		}
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	private func pushToProcessList() {
		let controller = ProcessListViewController()
		let busy = nodeStatus?.monitors.first(where: {$0.category == .Busy})
		let qLength = nodeStatus?.monitors.first(where: {$0.category == .QueueLength})
		controller.busy = busy
		controller.qLength = qLength
		if let alertLimit = nodeAlert?.alertlimits.filter({ (limit) -> Bool in
			return limit.object == .Process &&
				limit.entity == .busy ||
				limit.entity == .queueLength
		}) {
			controller.alert = alertLimit
		}
		self.navigationController?.pushViewController(controller, animated: true)
	}
}

extension NodeViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = cells[indexPath.row]
		
		switch cell {
		case .cpu:
			pushToCPUList()
		case .ipu:
			pushToIPUList()
		case .disk:
			pushToDiskList()
		case .process:
			pushToProcessList()
		}
	}
	
}

extension NodeViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cells.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: NodeTableViewCell.identifier) as? NodeTableViewCell else {
			return UITableViewCell()
		}
		
		cell.configureCell(cellType: cells[indexPath.row])
		cell.selectionStyle = .none
		
		return cell
	}
	
	
	
}
