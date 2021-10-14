//
//  DiskDetailViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 11/10/21.
//

import UIKit

class DiskDetailViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
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
		self.title = "Disk"
	}
	
	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		tableView.separatorInset = UIEdgeInsets(top: 1, left: 40, bottom: 1, right: 40)
		tableView.separatorColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1)
		tableView.register(UINib(nibName: StatusDetailTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: StatusDetailTableViewCell.identifier)
	}
	
	private func createSectionHeader() -> UIView {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
		view.backgroundColor = .white
		
		let textColor = UIColor(red: 61.0/255.0, green: 61.0/255.0, blue: 61.0/255.0, alpha: 1)
		let font = UIFont.systemFont(ofSize: 12)
		
		let nameLabel = UILabel()
		nameLabel.text = "Name"
		nameLabel.textColor = textColor
		nameLabel.font = font
		nameLabel.textAlignment = .center
		
		let busyLabel = UILabel()
		busyLabel.text = "Busy"
		busyLabel.textColor = textColor
		busyLabel.font = font
		busyLabel.textAlignment = .center
		
		let lenghtLabel = UILabel()
		lenghtLabel.text = "Q Length"
		lenghtLabel.textColor = textColor
		lenghtLabel.font = font
		lenghtLabel.textAlignment = .center
		
		let stack = UIStackView(arrangedSubviews: [nameLabel, busyLabel, lenghtLabel])
		stack.frame = CGRect(x: 40, y: 0, width: tableView.frame.width - 80, height: 40)
		stack.axis = .horizontal
		stack.distribution = .fillEqually
		
		let separator = UIView(frame: CGRect(x: 40, y: 39, width: tableView.frame.width - 80, height: 1))
		separator.backgroundColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1)
		
		view.addSubview(stack)
		view.addSubview(separator)
		
		return view
	}
}

extension DiskDetailViewController: UITableViewDelegate {
	
}

extension DiskDetailViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: StatusDetailTableViewCell.identifier) as? StatusDetailTableViewCell else {
			return UITableViewCell()
		}
		
		cell.configureCell(name: "$X9ZG", busy: "10.08%", lenght: "1.00")
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return createSectionHeader()
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 40.0
	}
}
