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
	
	private let service = RegisterService()
	
	@IBAction func continueButtonTapped(_ sender: Any) {
		registerUser()
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
		NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	@objc func showKeyboard(_ notification: NSNotification) {
		if let userInfo = notification.userInfo,
			let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			DispatchQueue.main.async { [weak self] in
				self?.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
			}
		}
	}
	
	@objc func hideKeyboard(){
		DispatchQueue.main.async { [weak self] in
			self?.tableView.contentInset = UIEdgeInsets.zero
		}
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
	
	private func registerUser() {
		guard let firstName = getFirstNameText() else {
			showAlert(message: "First name cannot be empty")
			return
		}
		
		guard let lastName = getLastNameText() else {
			showAlert(message: "Last name cannot be empty")
			return
		}
		
		guard let email = getEmailText() else {
			showAlert(message: "Email address cannot be empty")
			return
		}
		
		guard let companyName = getCompanyNameText() else {
			showAlert(message: "Company name cannot be empty")
			return
		}
		
		guard let companyCountry = getCompanyCountryText() else {
			showAlert(message: "Company country cannot be empty")
			return
		}
		
		guard let companyCity = getCompanyCityText() else {
			showAlert(message: "Company city cannot be empty")
			return
		}
		
		guard email.isValidEmail() else {
			showAlert(message: "Email format is not valid")
			return
		}
		
		showLoading()
		service.register(
			firstName: firstName,
			lastName: lastName,
			email: email,
			companyName: companyName,
			companyCountry: companyCountry,
			companyState: companyCity
		) { [weak self] in
			self?.hideLoading()
			self?.presentOTP(email: email)
		} onFailed: { [weak self] (message) in
			self?.hideLoading()
			self?.showAlert(message: message)
		}
	}
	
	private func presentOTP(email: String) {
		let inputOTPVC = OTPVerificationViewController()
		inputOTPVC.modalPresentationStyle = .overCurrentContext
		inputOTPVC.onSuccessVerification = { [weak self] in
			self?.pushToServerInfo()
		}
		
		DispatchQueue.main.async { [weak self] in
			self?.present(inputOTPVC, animated: true, completion: nil)
		}
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
			label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
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

extension RegistrationViewController {
	private func getFirstNameText() -> String? {
		
		guard let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? RegistrationTableViewCell else {
			return nil
		}
		
		let (type, value) = cell.getValue()
		
		if type != .firstName {
			return nil
		}
		
		return value
	}
	
	private func getLastNameText() -> String? {
		
		guard let cell = tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as? RegistrationTableViewCell else {
			return nil
		}
		
		let (type, value) = cell.getValue()
		
		if type != .lastName {
			return nil
		}
		
		return value
	}
	
	private func getEmailText() -> String? {
		
		guard let cell = tableView.cellForRow(at: IndexPath(item: 2, section: 0)) as? RegistrationTableViewCell else {
			return nil
		}
		
		let (type, value) = cell.getValue()
		
		if type != .email {
			return nil
		}
		
		return value
	}
	
	private func getCompanyNameText() -> String? {
		
		guard let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 1)) as? RegistrationTableViewCell else {
			return nil
		}
		
		let (type, value) = cell.getValue()
		
		if type != .company {
			return nil
		}
		
		return value
	}
	
	private func getCompanyCountryText() -> String? {
		
		guard let cell = tableView.cellForRow(at: IndexPath(item: 1, section: 1)) as? RegistrationTableViewCell else {
			return nil
		}
		
		let (type, value) = cell.getValue()
		
		if type != .country {
			return nil
		}
		
		return value
	}
	
	private func getCompanyCityText() -> String? {
		
		guard let cell = tableView.cellForRow(at: IndexPath(item: 2, section: 1)) as? RegistrationTableViewCell else {
			return nil
		}
		
		let (type, value) = cell.getValue()
		
		if type != .city {
			return nil
		}
		
		return value
	}
}
