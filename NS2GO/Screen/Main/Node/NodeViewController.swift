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
	
	var rightBarButtonItem: UIBarButtonItem?
	
	var nodeAlert: Node?
	var nodeStatus: NodeStatus?
	var version: Version?
	
	private let refreshControl = UIRefreshControl()
	private let serviceHelper = ServiceHelper.shared
	private var isFirstTimeLoad: Bool = true
	
	private let cells: [NodeTableViewCell.CellType] = [.cpu, .ipu, .disk, .process]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		startSyncTimer()
		setupCompletion()
		setupVersionLabel()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationBar()
		
		isFirstTimeLoad = false
		updateLastSyncLabel()
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
		versionLabel.text = ""
		if let version = version?.version {
			let versionFormat = "WVP E. Version: "
			let fontColor = UIColor(red: 117.0/255.0, green: 117.0/255.0, blue: 117.0/255.0, alpha: 1)
			
			let versionPrefixString = NSAttributedString(string: versionFormat, attributes: [
				NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 14) ?? UIFont.systemFont(ofSize: 14),
				NSAttributedString.Key.foregroundColor: fontColor
			])
			let mutableAttrString = NSMutableAttributedString(attributedString: versionPrefixString)
			
			let versionAttrString = NSAttributedString(string: version, attributes: [
				NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-LightItalic", size: 14) ?? UIFont.italicSystemFont(ofSize: 14),
				NSAttributedString.Key.foregroundColor: fontColor
			])
			
			mutableAttrString.append(versionAttrString)
			
			versionLabel.attributedText = mutableAttrString
		}
	}
	
	private func setupNavigationBar() {
		self.setupDefaultNavigationBar()
		self.title = nodeStatus?.nodename
		if self.navigationController?.interactivePopGestureRecognizer?.delegate == nil {
			self.navigationController?.interactivePopGestureRecognizer?.delegate = self
		}
		
		let button = UIButton()
		button.setImage(UIImage(named : "ic_hamburger_menu"), for: .normal)
		button.setTitle("", for: .normal)
		button.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
		button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
		button.widthAnchor.constraint(equalToConstant: 44).isActive = true
		button.heightAnchor.constraint(equalToConstant: 44).isActive = true
		rightBarButtonItem = UIBarButtonItem(customView: button)
		self.navigationItem.rightBarButtonItem = rightBarButtonItem
	}
	
	@objc private func pushToAlertCriteria() {
		let controller = AlertCriteriaViewController()
		controller.nodename = self.nodeStatus?.nodename
		controller.alerts = self.nodeAlert?.alertlimits ?? []
		
		DispatchQueue.main.async {
			self.navigationController?.pushViewController(controller, animated: true)
		}
	}
	
	@objc private func showMenu() {
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let logout = UIAlertAction(title: "Logout", style: .default) { [weak self] (_) in
			self?.logOut()
		}
		
		let alertDef = UIAlertAction(title: "View Alert Def.", style: .default) { [weak self] (_) in
			self?.pushToAlertCriteria()
		}
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		alert.addAction(alertDef)
		alert.addAction(logout)
		alert.addAction(cancel)
		
		alert.view.tintColor = .black
		
		alert.popoverPresentationController?.barButtonItem = rightBarButtonItem
		
		self.present(alert, animated: true, completion: nil)
	}
	
	@objc private func logOut() {
		showAlert(
			title: "Logout",
			message: "Do you want to logout ?",
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
				
				let launchVC = LoginViewController()
				let navVC = UINavigationController(rootViewController: launchVC)
				
				ServiceHelper.shared.reset()
				
				if let font = UIFont(name: "HelveticaNeue-Light", size: 18) {
					navVC.navigationBar.titleTextAttributes = [
						NSAttributedString.Key.font: font,
						NSAttributedString.Key.foregroundColor: UIColor(red: 112.0/255.0, green: 112.0/255.0, blue: 112.0/255.0, alpha: 1)
					]
				}
				
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
			NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 12)
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
		if serviceHelper.neighborhood.count > 0 {
			serviceHelper.fetchAllStatusNode(onComplete: nil, onError: nil)
		} else {
			serviceHelper.nodeStatuses.removeAll()
			serviceHelper.fetchStatusData(onComplete: { [weak self] in
				self?.hideLoading()
				
				let nodeName = self?.nodeStatus?.nodename ?? ""
				self?.title = nodeName
				
				if let newStatus = self?.serviceHelper.nodeStatuses.first(where: {$0.nodename == nodeName}) {
					self?.nodeStatus = newStatus
					DispatchQueue.main.async { [weak self] in
						self?.tableView.reloadData()
					}
				}
				
				self?.updateLastSyncLabel()
			}, onError: { [weak self] message in
				self?.hideLoading()
				self?.showAlert(message: message)
			})
		}
	}
	
	private func setupCompletion() {
		let successCompletion = { [weak self] in
			self?.hideLoading()
			
			let nodeName = self?.nodeStatus?.nodename ?? ""
			self?.title = nodeName
			
			if let newStatus = self?.serviceHelper.nodeStatuses.first(where: {$0.nodename == nodeName}) {
				self?.nodeStatus = newStatus
				DispatchQueue.main.async { [weak self] in
					self?.tableView.reloadData()
				}
			}
			
			self?.updateLastSyncLabel()
		}
		
		let errorCompletion: (String) -> Void = { [weak self] message in
			self?.hideLoading()
			self?.showAlert(message: message)
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

extension NodeViewController: UIGestureRecognizerDelegate {
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		guard let nav = navigationController else {
			return false
		}
		
		return nav.viewControllers.count > 1
	}
}

