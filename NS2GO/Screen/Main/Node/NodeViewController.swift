//
//  NodeViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 10/10/21.
//

import UIKit
import KeychainAccess

class NodeViewController: UIViewController {

	@IBOutlet weak var lastSyncLabel: UILabel!
	@IBOutlet var headerView: UIView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var versionLabel: UILabel!
	
	
	var nodeStatus: NodeStatus?
	var nodeAlert: Node?
	
	private let refreshControl = UIRefreshControl()
	private let serviceHelper = ServiceHelper.shared
	
	private let cells: [NodeTableViewCell.CellType] = [.cpu, .ipu, .disk, .process]
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupTableView()
		startSyncTimer()
		setupCompletion()
		setupVersionLabel()
		updateLastSyncLabel()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationBar()
	}
	
	private func startSyncTimer() {
		Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { (_) in
			DispatchQueue.main.async { [weak self] in
				self?.updateLastSyncLabel()
			}
		}
	}
	
	private func updateLastSyncLabel() {
		let interval = Date().timeIntervalSince(serviceHelper.lastFetchTime)
		lastSyncLabel.text = "Last sync \(interval.toString()) ago"
	}
	
	private func setupVersionLabel() {
		let versionFormat = "WVPe Version: "
		versionLabel.text = ""
		if let version = serviceHelper.version {
			versionLabel.text = versionFormat + version
		} else {
			serviceHelper.getVersion { [weak self] (version) in
				self?.versionLabel.text = versionFormat + version
			}
		}
	}
 
	private func setupNavigationBar() {
		self.setupDefaultNavigationBar()
		self.title = nodeStatus?.nodename
		
		let button = UIButton()
		button.setImage(UIImage(named : "ic_logout"), for: .normal)
		button.setTitle("", for: .normal)
		button.addTarget(self, action: #selector(logOut), for: .touchUpInside)
		button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
		button.widthAnchor.constraint(equalToConstant: 44).isActive = true
		button.heightAnchor.constraint(equalToConstant: 44).isActive = true
		let btBar = UIBarButtonItem(customView: button)
		
		let alertCriteria = UIBarButtonItem(title: "Alerts", style: .plain, target: self, action: #selector(pushToAlertCriteria))
		self.navigationItem.rightBarButtonItems = [btBar, alertCriteria]
	}
	
	@objc private func pushToAlertCriteria() {
		let controller = AlertCriteriaViewController()
		controller.nodename = self.nodeStatus?.nodename
		controller.alerts = self.nodeAlert?.alertlimits ?? []
		
		DispatchQueue.main.async {
			self.navigationController?.pushViewController(controller, animated: true)
		}
	}
	
	@objc private func logOut() {
		showAlert(
			title: "Log Out",
			message: "Do you want to log out ?",
			buttonPositive: "Yes",
			buttonNegative: "No"
		) { [weak self] in
			DispatchQueue.main.async { [weak self] in
				
				let keychain = Keychain(service: NS2GOConstant.keychainIdentifier)
				do {
					try keychain.removeAll()
				} catch {
					print(error.localizedDescription)
				}
				
				let launchVC = LaunchViewController()
				let navVC = UINavigationController(rootViewController: launchVC)
				
				guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
					  let window = appDelegate.window else {
					return
				}
				
				window.rootViewController = navVC
			}
		}
	}
	
	private func setupTableView() {
		
		let attribute: [NSAttributedString.Key : Any] = [
			NSAttributedString.Key.foregroundColor: UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 202.0/225.0, alpha: 1),
			NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)
		]
		
		refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh", attributes: attribute)
		refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		tableView.tableHeaderView = headerView
		tableView.separatorStyle = .none
		tableView.refreshControl = refreshControl
		tableView.register(UINib(nibName: NodeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NodeTableViewCell.identifier)
	}
	
	@objc private func fetchData() {
		refreshControl.endRefreshing()
		showLoading()
		serviceHelper.fetchStatusData()
	}
	
	private func setupCompletion() {
		let successCompletion = { [weak self] in
			self?.hideLoading()
			
			let nodeName = self?.nodeStatus?.nodename ?? ""
			if let nodeStatus = self?.serviceHelper.nodeStatuses.first(where: {$0.nodename == nodeName}) {
				self?.nodeStatus = nodeStatus
			}
			
			DispatchQueue.main.async { [weak self] in
				self?.updateLastSyncLabel()
				self?.tableView.reloadData()
			}
		}
		
		let errorCompletion: (String) -> Void = { [weak self] message in
			self?.hideLoading()
		}
		
		serviceHelper.addSuccessCompletion(successCompletion)
		serviceHelper.addErrorCompletion(errorCompletion)
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
				(limit.entity == .busy ||
				limit.entity == .queueLength)
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
				(limit.entity == .busy ||
				limit.entity == .queueLength)
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
				(limit.entity == .busy ||
				limit.entity == .queueLength)
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
				(limit.entity == .busy ||
				limit.entity == .queueLength)
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
		
		var object: [ObjectMonitored] = []
		var alertLimit: [AlertLimit] = []
		
		switch indexPath.row {
		case 0:
			if let firstObject = nodeStatus?.monitors.first(where: {$0.category == .CPU}),
			   let allAlertLimits = nodeAlert?.alertlimits {
				object = [firstObject]
				alertLimit = allAlertLimits.filter({$0.object == .CPU})
			}
		case 1:
			if let firstObject = nodeStatus?.monitors.first(where: {$0.category == .CPU}),
			   let allAlertLimits = nodeAlert?.alertlimits  {
				object = [firstObject]
				alertLimit = allAlertLimits.filter({$0.object == .IPU})
			}
		case 2:
			if let firstObject = nodeStatus?.monitors.first(where: {$0.category == .DiskBusy}),
			   let secondObject = nodeStatus?.monitors.first(where: {$0.category == .DiskQueueLength}),
			   let allAlertLimits = nodeAlert?.alertlimits  {
				object = [firstObject, secondObject]
				alertLimit = allAlertLimits.filter({$0.object == .Disk})
			}
		case 3:
			if let firstObject = nodeStatus?.monitors.first(where: {$0.category == . Busy}),
			   let secondObject = nodeStatus?.monitors.first(where: {$0.category == .QueueLength}),
			   let allAlertLimits = nodeAlert?.alertlimits  {
				object = [firstObject, secondObject]
				alertLimit = allAlertLimits.filter({$0.object == .Process})
			}
			
		default:
			return UITableViewCell()
		}
		
		cell.configureCell(cellType: cells[indexPath.row], objects: object, nodeAlert: alertLimit)
		cell.selectionStyle = .none
		
		return cell
	}
	
	
	
}
