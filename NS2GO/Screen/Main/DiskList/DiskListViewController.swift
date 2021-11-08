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
			
			controller.alert = alert
		} else {
			controller.title = "DISK Q. LENGTH"
			if let instances = qLength?.instance as? [DiskProcessInstance] {
				controller.instances = instances.sorted(by: { (left, right) -> Bool in
					return (left.queueLength ?? 0) > (right.queueLength ?? 0)
				}).chunked(into: 5).first ?? []
			}
			
			controller.alert = alert
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
		
		if indexPath.row == 0,
		   let processInstance = self.busy?.instance as? [DiskProcessInstance],
		   let alert = self.alert.first(where: {$0.entity == .busy}),
		   let topProcess = processInstance.sorted(by: {$0.dp2Busy ?? 0 > $1.dp2Busy ?? 0}).first {
			cell.configureCell(text: "DP2 BUSY%", topProcess: topProcess, alert: alert)
		} else if let processInstance = self.qLength?.instance as? [DiskProcessInstance],
				  let alert = self.alert.first(where: {$0.entity == .queueLength}),
				  let topProcess = processInstance.sorted(by: {$0.queueLength ?? 0 > $1.queueLength ?? 0}).first {
			cell.configureCell(text: "Q. LENGTH", topProcess: topProcess, alert: alert)
		}
		
		cell.selectionStyle = .none
		
		return cell
	}
}
