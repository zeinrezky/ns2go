//
//  ResponseListViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 22/10/21.
//

import UIKit

class ResponseListViewController: UIViewController {

	
	@IBOutlet weak var tableView: UITableView!
	
	var responses: [[String: Any]?] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupTableView()
    }
	
	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
	}
}

extension ResponseListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let response = responses[indexPath.row]
		
		let controller = ResponseDetailViewController()
		controller.response = response
		
		self.navigationController?.pushViewController(controller, animated: true)
	}
}

extension ResponseListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return responses.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
		let response = responses[indexPath.row]
		cell.textLabel?.text = response?["response_name"] as? String
		
		return cell
	}
}
