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
	
	private var isTnCChecked: Bool = false {
		didSet {
			if isTnCChecked {
				checkTnC()
			} else {
				uncheckTnC()
			}
		}
	}
	
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
	
	
	@IBAction func tncButtonTapped(_ sender: Any) {
		isTnCChecked = !isTnCChecked
	}
	
	private let cells: [[RegistrationTableViewCell.CellType]] = [
		[.firstName, .lastName, .email],
		[.company, .country, .city]
	]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationBar()
	}
	
	private func setupNavigationBar() {
		self.setupDefaultNavigationBar()
	}
	
	private func setupView() {
		setupTableView()
		uncheckTnC()
		continueButton.layer.cornerRadius = 4
		checkboxView.isUserInteractionEnabled = false
	}
	
	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableHeaderView = headerView
		tableView.tableFooterView = footerView
		tableView.separatorStyle = .none
		tableView.backgroundColor = .white
		tableView.register(UINib(nibName: RegistrationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RegistrationTableViewCell.identifier)
	}
	
	private func checkTnC() {
		let blueColor = UIColor(red: 83.0/255.0, green: 127.0/255.0, blue: 227.0/255.0, alpha: 1)
		checkboxView.layer.borderColor = blueColor.cgColor
		checkboxView.backgroundColor = blueColor
		let width = checkboxView.frame.width
		
		let insideStrokeLayer = CAShapeLayer()
		insideStrokeLayer.accessibilityLabel = "insideStroke"
		insideStrokeLayer.path = UIBezierPath(roundedRect: CGRect(x: 1, y: 1, width: width - 2, height: width - 2), cornerRadius: 0).cgPath
		insideStrokeLayer.strokeColor = UIColor.white.cgColor
		insideStrokeLayer.borderWidth = 3
		insideStrokeLayer.fillColor = UIColor.clear.cgColor
		checkboxView.layer.addSublayer(insideStrokeLayer)
	}
	
	private func uncheckTnC() {
		checkboxView.layer.borderWidth = 1
		checkboxView.layer.borderColor = UIColor.black.cgColor
		checkboxView.backgroundColor = .white
		
		checkboxView.layer.sublayers?.removeAll(where: {$0.accessibilityLabel == "insideStroke"})
	}

	private func pushToServerInfo() {
		let serverVC = ServerInformationViewController()
		DispatchQueue.main.async { [weak self] in
			self?.navigationController?.pushViewController(serverVC, animated: true)
		}
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
			let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
			let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
			label.text = "Company Information"
			label.textAlignment = .center
			label.textColor = .darkGray
			view.addSubview(label)
			
			return view
		}
		
		return nil
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return UIView()
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 1 {
			return 40.0
		}
		
		return 0
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		if section == 0 {
			return 60.0
		}
		
		return 0
	}
	
}
