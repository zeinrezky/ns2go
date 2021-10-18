//
//  ServerListViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 10/10/21.
//

import UIKit

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
