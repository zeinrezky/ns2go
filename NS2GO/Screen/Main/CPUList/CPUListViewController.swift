//
//  CPUListViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 11/10/21.
//

import UIKit

class CPUListViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	var cpu: ObjectMonitored?
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
	}
 
	private func setupNavigationBar() {
		self.setupDefaultNavigationBar()
		self.title = "CPU"
	}
	
	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		tableView.separatorInset = UIEdgeInsets(top: 1, left: 40, bottom: 1, right: 40)
		tableView.separatorColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1)
		tableView.register(UINib(nibName: StatusListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: StatusListTableViewCell.identifier)
    }
	
	private func createSectionHeader(for text: String) -> UIView {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
		view.backgroundColor = .white
		
		let separator = UIView(frame: CGRect(x: 40, y: 59, width: tableView.frame.width - 80, height: 1))
		separator.backgroundColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1)
		
		let label = UILabel(frame: CGRect(x: 40, y: 30, width: tableView.frame.width - 80, height: 20))
		label.text = text
		label.textColor = UIColor(red: 61.0/255.0, green: 61.0/255.0, blue: 61.0/255.0, alpha: 1)
		label.font = UIFont.systemFont(ofSize: 16)
		
		view.addSubview(label)
		view.addSubview(separator)
		
		return view
	}
}

extension CPUListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let controller = CPUDetailViewController()
		let cpuName = cpu?.instance[indexPath.section].name ?? ""
		
		if indexPath.row == 0 {
			if let instances = busy?.instance as? [CPUProcessInstance] {
				let filtered = instances.filter({$0.cpunumber == Int(cpuName)})
				controller.instances = filtered
			}
		} else {
			if let instances = qLength?.instance as? [CPUProcessInstance] {
				let filtered = instances.filter({$0.cpunumber == Int(cpuName)})
				controller.instances = filtered
			}
		}
		
		controller.alert = self.alert
		
		self.navigationController?.pushViewController(controller, animated: true)
	}
}

extension CPUListViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return cpu?.instance.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: StatusListTableViewCell.identifier) as? StatusListTableViewCell,
			  let instance: CPU = cpu?.instance[indexPath.section] as? CPU else {
			return UITableViewCell()
		}
	
		let entity: AlertLimit.EntityType = indexPath.row == 0 ? .busy : .queueLength
		
		let alertLimit = alert.first(where: {$0.entity == entity})
		
		cell.configureCell(alertLimit: alertLimit, instance: instance, row: indexPath.row)
		cell.selectionStyle = .none
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		var headerText: String = ""
		if let instance = cpu?.instance[section] as? CPU {
			headerText = (instance.name ?? "")
		}
		return createSectionHeader(for: headerText)
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 60.0
	}
}
