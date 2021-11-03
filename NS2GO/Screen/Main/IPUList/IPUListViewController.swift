//
//  IPUListViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 11/10/21.
//

import UIKit

class IPUListViewController: UIViewController {
	
	
	@IBOutlet weak var tableView: UITableView!
	
	var cpu: ObjectMonitored?
	var busy: ObjectMonitored?
	var qLength: ObjectMonitored?
	
	var alert: [AlertLimit] = []
	
	var ipus: [IPU] {
		guard let cpus = cpu?.instance as? [CPU] else {
			return []
		}
		
		let ipus: [IPU] = cpus.flatMap({$0.ipus})
		
		return ipus
	}
	
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
		self.title = "IPU"
	}
	
	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		tableView.separatorStyle = .none
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
		label.font = UIFont(name: "HelveticaNeue", size: 16)
		
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
		
		let ipu = ipus[section]
		if let cpuNumber = Int(ipu.cpuName ?? ""),
		   let ipuNumber = ipu.ipunumber {
			
				if let instances = busy?.instance as? [CPUProcessInstance] {
					let filtered = instances.filter({$0.cpunumber == cpuNumber && $0.ipunumber == ipuNumber})
					controller.instances = filtered.sorted(by: { (left, right) -> Bool in
						return (left.cpuBusy ?? 0) > (right.cpuBusy ?? 0)
					}).chunked(into: 5).first ?? []
				}
			
		}
		
		controller.navTitle = "IPU \(ipu.displayName) Busiest Processes"
		controller.alert = self.alert
		
		DispatchQueue.main.async { [weak self] in
			self?.navigationController?.pushViewController(controller, animated: true)
		}
	}
}

extension IPUListViewController: UITableViewDelegate {

}

extension IPUListViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return ipus.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: DualStatusListTableViewCell.identifier) as? DualStatusListTableViewCell else {
			return UITableViewCell()
		}
		
		let instance: IPU = ipus[indexPath.section]
		
		cell.configureCell(alertLimits: alert, instance: instance)
		cell.selectionStyle = .none
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let ipu = ipus[section]
		return createSectionHeader(for: ipu.displayName, section: section)
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 60.0
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return .leastNonzeroMagnitude
	}
}
