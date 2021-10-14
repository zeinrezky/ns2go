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

}

extension ServerListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let controller = NodeViewController()
		self.navigationController?.pushViewController(controller, animated: true)
	}
}

extension ServerListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ServerListTableViewCell.identifier) as? ServerListTableViewCell else {
			return UITableViewCell()
		}
		
		cell.selectionStyle = .none
		
		return cell
	}
}
