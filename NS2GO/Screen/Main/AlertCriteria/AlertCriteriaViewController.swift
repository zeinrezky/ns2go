//
//  AlertCriteriaViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 23/10/21.
//

import UIKit

class AlertCriteriaViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	private var sections: [AlertLimit.ObjectType] = [.CPU, .IPU, .Disk, .Process]
	
	var nodename: String?
	var alerts: [AlertLimit] = []
	
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
		self.title = "\(nodename ?? "") Alert Definitions"
	}
	
	private func setupTableView() {
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		tableView.separatorStyle = .none
		tableView.register(UINib(nibName: AlertCriteriaTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AlertCriteriaTableViewCell.identifier)
	}
	
	private func createSectionHeader(for text: String, section: Int) -> UIView {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
		view.backgroundColor = .white
		view.tag = section
		
		let separator = UIView(frame: CGRect(x: 40, y: 59, width: tableView.frame.width - 80, height: 1))
		separator.backgroundColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1)
		
		let label = UILabel(frame: CGRect(x: 40, y: 30, width: tableView.frame.width - 120, height: 20))
		label.text = text
		label.textColor = UIColor(red: 117.0/255.0, green: 117.0/255.0, blue: 117.0/255.0, alpha: 1)
		label.font = UIFont(name: "HelveticaNeue", size: 16)
		
		view.addSubview(label)
		view.addSubview(separator)
		
		return view
	}
}

extension AlertCriteriaViewController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: AlertCriteriaTableViewCell.identifier) as? AlertCriteriaTableViewCell else {
			return UITableViewCell()
		}
		
		let object: AlertLimit.ObjectType = sections[indexPath.section]
		let busyEntity: AlertLimit.EntityType = .busy
		let qlengthEntity: AlertLimit.EntityType = .queueLength
		
		guard let busyAlert = alerts.first(where: {$0.object == object && $0.entity == busyEntity}),
			  let qlengthAlert = alerts.first(where: {$0.object == object && $0.entity == qlengthEntity}) else {
			return UITableViewCell()
		}
		
		cell.configureCell(busyAlert: busyAlert, qLengthAlert: qlengthAlert)
		cell.selectionStyle = .none
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return createSectionHeader(for: sections[section].rawValue.uppercased(), section: section)
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 60
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat.leastNonzeroMagnitude
	}
	
}
