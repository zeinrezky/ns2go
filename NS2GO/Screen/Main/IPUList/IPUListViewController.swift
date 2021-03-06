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
	var nodename: String?
	
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
		self.title = (nodename ?? "").isEmpty ? "IPU" : "\(nodename ?? ""): IPU"
	}
	
	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		tableView.separatorStyle = .none
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
		tableView.register(UINib(nibName: DualStatusListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DualStatusListTableViewCell.identifier)
	}
	
	private func createSectionHeader(for text: String, section: Int, processCount: Int) -> UIView {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
		view.backgroundColor = .white
		view.tag = section
		
		let separator = UIView(frame: CGRect(x: 40, y: 59, width: tableView.frame.width - 80, height: 1))
		separator.backgroundColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1)
		
		let stackView = UIStackView(frame: CGRect(x: 40, y: 30, width: tableView.frame.width - 80, height: 20))
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 8
		
		let label = UILabel(frame: CGRect.zero)
		label.text = text
		label.textColor = UIColor(red: 61.0/255.0, green: 61.0/255.0, blue: 61.0/255.0, alpha: 1)
		label.font = UIFont(name: "HelveticaNeue-Thin", size: 16)
		label.sizeToFit()
		
		let icon = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
		icon.widthAnchor.constraint(equalToConstant: 16).isActive = true
		icon.heightAnchor.constraint(equalToConstant: 16).isActive = true
		icon.image = UIImage(named: "ic_rightArrow")
		icon.contentMode = .scaleAspectFit
		
		let countLabel = UILabel(frame: CGRect.zero)
		let textColor = processCount > 0 ? UIColor(red: 61.0/255.0, green: 61.0/255.0, blue: 61.0/255.0, alpha: 1) : UIColor(red: 173.0/255.0, green: 173.0/255.0, blue: 173.0/255.0, alpha: 1)
		countLabel.font = UIFont(name: "HelveticaNeue-LightItalic", size: 12)
		countLabel.textColor = textColor
		countLabel.textAlignment = .right
		countLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		
		if processCount > 0 {
			countLabel.text = "Top \(processCount) process\(processCount > 1 ? "es" : "")"
		} else {
			countLabel.text = "No top process data"
		}
		
		stackView.addArrangedSubview(label)
		stackView.addArrangedSubview(countLabel)
		stackView.addArrangedSubview(icon)
		
		view.addSubview(stackView)
		view.addSubview(separator)
		
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
				
				guard filtered.count > 0 else {
					return
				}
				
				controller.instances = filtered.sorted(by: { (left, right) -> Bool in
					return (left.cpuBusy ?? 0) > (right.cpuBusy ?? 0)
				})
			}
		}
		
		let nodenameString = (nodename ?? "").isEmpty ? "" : "\(nodename ?? ""): "
		controller.navTitle = "\(nodenameString)IPU \(ipu.displayName) Busiest Processes"
		controller.alert = self.alert.filter({$0.object == .Process})
		
		DispatchQueue.main.async { [weak self] in
			self?.navigationController?.pushViewController(controller, animated: true)
		}
	}
}

extension IPUListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		pushToDetail(section: indexPath.section)
	}
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
		let ipuAlert = alert.filter({$0.object == .IPU})
		
		cell.configureCell(alertLimits: alert, instance: instance)
		cell.selectionStyle = .none
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let ipu = ipus[section]
		var count: Int = 0
		if let cpuNumber = Int(ipu.cpuName ?? ""),
		   let ipuNumber = ipu.ipunumber {
			
			if let instances = busy?.instance as? [CPUProcessInstance] {
				let filtered = instances.filter({$0.cpunumber == cpuNumber && $0.ipunumber == ipuNumber})
				
				count = filtered.count
			}
		}
		
		return createSectionHeader(for: ipu.displayName, section: section, processCount: count)
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 60.0
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return .leastNonzeroMagnitude
	}
}
