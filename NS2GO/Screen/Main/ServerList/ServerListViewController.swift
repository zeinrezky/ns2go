//
//  ServerListViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 10/10/21.
//

import UIKit
import KeychainAccess

class ServerListViewController: UIViewController {

	@IBOutlet weak var lastSyncLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet var headerView: UIView!
	
	var nodeAlert: [Node] {
		return serviceHelper.nodeAlert
	}
	
	var nodeStatuses: [NodeStatus] {
		return serviceHelper.nodeStatuses
	}
	
	var versions: [Version] {
		return serviceHelper.versions
	}
	
	var neighborhoods: [Neighborhood] {
		return serviceHelper.neighborhood
	}
	
	private var rightBarButtonItem: UIBarButtonItem?
	
	private var isFirstTimeLoad: Bool = true
	private let serviceHelper = ServiceHelper.shared
	private let refreshControl = UIRefreshControl()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupTableView()
		setupCompletion()
		startSyncTimer()
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
	
	private func setupNavigationBar() {
		self.setupDefaultNavigationBar()
		self.title = "NS2GO"
		self.navigationController?.interactivePopGestureRecognizer?.delegate = self
		
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
	
	@objc private func showMenu() {
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let logout = UIAlertAction(title: "Logout", style: .default) { [weak self] (_) in
			self?.logOut()
		}
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		alert.addAction(logout)
		alert.addAction(cancel)
		
		alert.view.tintColor = .black
		
		alert.popoverPresentationController?.barButtonItem = rightBarButtonItem
		
		self.present(alert, animated: true, completion: nil)
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
		tableView.tableHeaderView = headerView
		tableView.tableFooterView = UIView()
		tableView.separatorStyle = .none
		tableView.refreshControl = refreshControl
		tableView.register(UINib(nibName: ServerListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ServerListTableViewCell.identifier)
	}
	
	private func setupCompletion() {
		let successCompletion = { [weak self] in
			self?.hideLoading()
			DispatchQueue.main.async { [weak self] in
				self?.updateLastSyncLabel()
				self?.tableView.reloadData()
			}
		}
		
		let errorCompletion: (String) -> Void = { [weak self] message in
			self?.hideLoading()
			self?.showAlert(message: message)
		}
		
		serviceHelper.addSuccessCompletion(successCompletion)
		serviceHelper.addErrorCompletion(errorCompletion)
	}
	
	@objc private func fetchData() {
		refreshControl.endRefreshing()
		showLoading()
		serviceHelper.fetchAllStatusNode(onComplete: nil, onError: nil)
	}
}

extension ServerListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? ServerListTableViewCell,
			  let nodeStatus = getNodeStatus(for: cell.nodename) else {
			return
		}
		
		let controller = NodeViewController()
		
		controller.nodeAlert = serviceHelper.nodeAlert.first(where: { (node) -> Bool in
			var nodename = node.nodename
			if !nodename.starts(with: "\\") {
				nodename = "\\\(node.nodename)"
			}
			
			return (nodeStatus.nodename ?? "") == nodename
		})
		controller.nodeStatus = nodeStatus
		controller.version = serviceHelper.versions.first(where: {$0.systemname == (nodeStatus.nodename ?? "")})
		
		self.navigationController?.pushViewController(controller, animated: true)
	}
}

extension ServerListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return neighborhoods.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ServerListTableViewCell.identifier) as? ServerListTableViewCell else {
			return UITableViewCell()
		}
		let neighborhood = neighborhoods[indexPath.row]
		
		if let status = getNodeStatus(for: neighborhood.sysName) {
			cell.configureCell(node: status)
		} else {
			cell.configureCell(neighborhood: neighborhood)
		}
		cell.selectionStyle = .none
		
		return cell
	}
	
	func getNodeStatus(for nodename: String) -> NodeStatus? {
		let versionName = versions.map({$0.systemname})
		let alertName = nodeAlert.map { (alert) -> String in
			var nodename = alert.nodename
			if !nodename.starts(with: "\\") {
				nodename = "\\\(alert.nodename)"
			}
			
			return nodename
		}
		
		guard versionName.contains(nodename),
			  alertName.contains(nodename) else {
			return nil
		}
		
		guard let status = nodeStatuses.first(where: {$0.nodename == nodename}) else {
			return nil
		}
		
		return status
	}
}

extension ServerListViewController: UIGestureRecognizerDelegate {
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		guard let nav = navigationController else {
			return false
		}
		
		return nav.viewControllers.count > 1
	}
}
