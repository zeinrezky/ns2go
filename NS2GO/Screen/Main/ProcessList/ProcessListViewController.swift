//
//  ProcessListViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 11/10/21.
//

import UIKit

class ProcessListViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	var busy: ObjectMonitored?
	var qLength: ObjectMonitored?
	
	var alert: [AlertLimit] = []
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupTableView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationBar()
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
 
	private func setupNavigationBar() {
		self.setupDefaultNavigationBar()
		self.title = "Process"
	}
	
	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		tableView.separatorStyle = .none
		tableView.register(UINib(nibName: StatusListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: StatusListTableViewCell.identifier)
	}
}

extension ProcessListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let controller = ProcessDetailViewController()
		if indexPath.row == 0 {
			controller.title = "Busy %"
			if let instances = busy?.instance as? [CPUProcessInstance] {
				controller.instances = instances.sorted(by: { (left, right) -> Bool in
					return (left.cpuBusy ?? 0) > (right.cpuBusy ?? 0)
				}).chunked(into: 5).first ?? []
			}
			
			if let busyAlert = self.alert.first(where: {$0.entity == .busy}) {
				controller.alert = [busyAlert]
			}
		} else {
			controller.title = "Q. Length"
			if let instances = qLength?.instance as? [CPUProcessInstance] {
				controller.instances = instances.sorted(by: { (left, right) -> Bool in
					return (left.queueLength ?? 0) > (right.queueLength ?? 0)
				}).chunked(into: 5).first ?? []
			}
			
			if let qlengthAlert = self.alert.first(where: {$0.entity == .queueLength}) {
				controller.alert = [qlengthAlert]
			}
		}
		
		self.navigationController?.pushViewController(controller, animated: true)
	}
}

extension ProcessListViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: StatusListTableViewCell.identifier) as? StatusListTableViewCell else {
			return UITableViewCell()
		}
		
		var text: String = ""
		var indicator: StatusIndicator = .green
		
		if indexPath.row == 0,
		   let busy = self.busy {
			text = "Busy %"
			indicator = busy.getIndicator(alertLimits: alert)
		} else if let qLength = self.qLength {
			text = "Q. Length"
			indicator = qLength.getIndicator(alertLimits: alert)
		}
		
		cell.configureCell(status: indicator, text: text)
		cell.selectionStyle = .none
		
		return cell
	}
}
