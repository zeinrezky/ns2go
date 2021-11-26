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
		tableView.separatorStyle = .none
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
		tableView.register(UINib(nibName: DualStatusListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DualStatusListTableViewCell.identifier)
    }
	
	private func createSectionHeader(for text: String, section: Int) -> UIView {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
		view.backgroundColor = .white
		view.tag = section
		
		let separator = UIView(frame: CGRect(x: 40, y: 59, width: tableView.frame.width - 80, height: 1))
		separator.backgroundColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1)
		
		let label = UILabel(frame: CGRect(x: 40, y: 30, width: tableView.frame.width - 120, height: 20))
		label.text = text
		label.textColor = UIColor(red: 61.0/255.0, green: 61.0/255.0, blue: 61.0/255.0, alpha: 1)
		label.font = UIFont(name: "HelveticaNeue-Thin", size: 16)
		
		let icon = UIImageView(frame: CGRect(x: tableView.frame.width - 56, y: 30, width: 16, height: 16))
		icon.widthAnchor.constraint(equalToConstant: 16).isActive = true
		icon.heightAnchor.constraint(equalToConstant: 16).isActive = true
		icon.image = UIImage(named: "ic_rightArrow")
		icon.contentMode = .scaleAspectFit
		
		view.addSubview(label)
		view.addSubview(separator)
		view.addSubview(icon)
		
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeaderSection(_:))))
		
		return view
	}
	
	@objc private func didTapHeaderSection(_ gesture: UITapGestureRecognizer) {
		let view = gesture.view
		guard let tag = view?.tag else {
			return
		}
		
		pushToDetail(section: tag)
	}
	
	private func pushToDetail(section: Int) {
		let controller = CPUDetailViewController()
		let cpuName = cpu?.instance[section].name ?? ""
		
		if let cpu = cpu?.instance[section] as? CPU {
			controller.navTitle = "CPU \(cpu.displayName) Busiest Processes"
		}
		
		if let instances = busy?.instance as? [CPUProcessInstance] {
			let filtered = instances.filter({$0.cpunumber == Int(cpuName)})
			controller.instances = filtered.sorted(by: { (left, right) -> Bool in
				return (left.cpuBusy ?? 0) > (right.cpuBusy ?? 0)
			})
		}
		
		controller.alert = self.alert.filter({$0.object == .Process})
		
		DispatchQueue.main.async { [weak self] in
			self?.navigationController?.pushViewController(controller, animated: true)
		}
	}
}

extension CPUListViewController: UITableViewDelegate {
	
}

extension CPUListViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return cpu?.instance.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: DualStatusListTableViewCell.identifier) as? DualStatusListTableViewCell,
			  let instance: CPU = cpu?.instance[indexPath.section] as? CPU else {
			return UITableViewCell()
		}
		
		let cpuAlert = alert.filter({$0.object == .CPU})
		
		cell.configureCell(alertLimits: cpuAlert, instance: instance)
		cell.selectionStyle = .none
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		var headerText: String = ""
		if let instance = cpu?.instance[section] as? CPU {
			headerText = instance.displayName
		}
		
		return createSectionHeader(for: headerText, section: section)
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 60.0
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return .leastNonzeroMagnitude
	}
}
