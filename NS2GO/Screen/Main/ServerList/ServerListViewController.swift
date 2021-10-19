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
	
	var nodeAlert: Node?
	
	private var lastTimeFetch: Date = Date()
	private let service = DashboardService()
	
	private var isFirstTimeLoad: Bool = true
	
	private var nodeStatuses: [NodeStatus] = []

	override func viewDidLoad() {
        super.viewDidLoad()
		setupTableView()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationBar()
		
		if isFirstTimeLoad {
			fetchData()
		}
		
		isFirstTimeLoad = false
	}
	
	private func setupNavigationBar() {
		self.setupDefaultNavigationBar()
		self.title = "NS2GO"
		
		let button = UIButton()
		button.setImage(UIImage(named : "ic_logout"), for: .normal)
		button.setTitle("", for: .normal)
		button.addTarget(self, action: #selector(logOut), for: .touchUpInside)
		button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
		button.widthAnchor.constraint(equalToConstant: 44).isActive = true
		button.heightAnchor.constraint(equalToConstant: 44).isActive = true
		let btBar = UIBarButtonItem(customView: button)
		self.navigationItem.rightBarButtonItem = btBar
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
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableHeaderView = headerView
		tableView.tableFooterView = UIView()
		tableView.separatorStyle = .none
		tableView.register(UINib(nibName: ServerListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ServerListTableViewCell.identifier)
	}
	
	private func fetchData() {
		showLoading()
		service.getCurrentStatus(onComplete: { [weak self] nodeStatus in
			self?.hideLoading()
			self?.nodeStatuses = [nodeStatus]
			DispatchQueue.main.async { [weak self] in
				self?.tableView.reloadData()
			}
		}, onFailed: { [weak self] message in
			self?.hideLoading()
			DispatchQueue.main.async { [weak self] in
				self?.showAlert(message: message)
			}
		})
	}
}

extension ServerListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let nodeStatus = nodeStatuses[indexPath.item]
		
		let controller = NodeViewController()
		controller.nodeStatus = nodeStatus
		controller.nodeAlert = nodeAlert
		self.navigationController?.pushViewController(controller, animated: true)
	}
}

extension ServerListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return nodeStatuses.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ServerListTableViewCell.identifier) as? ServerListTableViewCell else {
			return UITableViewCell()
		}
		
		cell.configureCell(node: nodeStatuses[indexPath.item])
		cell.selectionStyle = .none
		
		return cell
	}
}
