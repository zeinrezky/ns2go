//
//  DiskListViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 11/10/21.
//

import UIKit

class DiskListViewController: UIViewController {
	
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
		self.title = "DISK"
	}
	
	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
		tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
		tableView.register(UINib(nibName: StatusListTableViewCell.identifier, bundle: nil),
						   forCellReuseIdentifier: StatusListTableViewCell.identifier)
	}
}

extension DiskListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let controller = DiskDetailViewController()
		if indexPath.row == 0 {
			controller.title = "DISK DP2 BUSY %"
			
			if let instances = busy?.instance as? [DiskProcessInstance] {
				controller.instances = instances.sorted(by: { (left, right) -> Bool in
					return (left.dp2Busy ?? 0) > (right.dp2Busy ?? 0)
				}).chunked(into: 5).first ?? []
			}
			
			if let busyAlert = self.alert.first(where: {$0.entity == .busy}) {
				controller.alert = [busyAlert]
			}
		} else {
			controller.title = "DISK Q. LENGTH"
			if let instances = qLength?.instance as? [DiskProcessInstance] {
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

extension DiskListViewController: UITableViewDataSource {
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
		   let busy = self.busy,
		   let alert = self.alert.first(where: {$0.entity == .busy}) {
			text = "DP2 BUSY%"
			indicator = busy.getIndicator(alertLimits: [alert])
		} else if let qLength = self.qLength,
				  let alert = self.alert.first(where: {$0.entity == .queueLength}) {
			text = "Q. LENGTH"
			indicator = qLength.getIndicator(alertLimits: [alert])
		}
		
		cell.configureCell(status: indicator, text: text)
		cell.selectionStyle = .none
		
		return cell
	}
}
