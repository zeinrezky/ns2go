//
//  RegistrationViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 09/10/21.
//

import UIKit

class RegistrationViewController: UIViewController {
	
	@IBOutlet var headerView: UIView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet var footerView: UIView!
	@IBOutlet weak var checkboxView: UIView!
	
	@IBOutlet weak var continueButton: UIButton!
	
	@IBAction func continueButtonTapped(_ sender: Any) {
		let inputOTPVC = OTPVerificationViewController()
		inputOTPVC.modalPresentationStyle = .overCurrentContext
		inputOTPVC.onSuccessVerification = { [weak self] in
			self?.pushToServerInfo()
		}
		
		DispatchQueue.main.async { [weak self] in
			self?.present(inputOTPVC, animated: true, completion: nil)
		}
	}
	
	private let cells: [[RegistrationTableViewCell.CellType]] = [
		[.firstName, .lastName, .email],
		[.company, .country, .city]
	]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupTableView()
    }
	
	private func pushToServerInfo() {
		let serverVC = ServerInformationViewController()
		DispatchQueue.main.async { [weak self] in
			self?.navigationController?.pushViewController(serverVC, animated: true)
		}
	}
	
	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableHeaderView = headerView
		tableView.tableFooterView = footerView
		tableView.separatorStyle = .none
		tableView.register(UINib(nibName: RegistrationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RegistrationTableViewCell.identifier)
	}
	
	private func setupCheckboxView() {
		
	}

}

extension RegistrationViewController: UITableViewDelegate {
	
	
}

extension RegistrationViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return cells.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cells[section].count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: RegistrationTableViewCell.identifier) as? RegistrationTableViewCell else {
			return UITableViewCell()
		}
		
		let cellType = cells[indexPath.section][indexPath.row]
		
		cell.configureCell(type: cellType)
		cell.selectionStyle = .none
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section == 1 {
			let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
			let label = UILabel(frame: CGRect(x: 0, y: 50, width: tableView.frame.width, height: 20))
			label.text = "Company Information"
			label.textAlignment = .center
			label.textColor = .darkGray
			view.addSubview(label)
			
			return view
		}
		
		return nil
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 1 {
			return 100.0
		}
		
		return 0
	}
	
}
