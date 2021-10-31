//
//  RegistrationViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 09/10/21.
//

import UIKit
import SafariServices

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
	
	private var registrationCells: [RegistrationTableViewCell] = []
	
	@IBAction func continueButtonTapped(_ sender: Any) {
		registerUser()
	}
	
	@IBAction func tncAgreeButtonTapped(_ sender: Any) {
		isTnCChecked = !isTnCChecked
	}
	
	@IBAction func tncShowButtonTapped(_ sender: Any) {
		guard let url = URL(string: BaseURL.shared.tncURL) else {
			return
		}
		
		let configuration = SFSafariViewController.Configuration()
		configuration.barCollapsingEnabled = true
		
		let safariVC = SFSafariViewController(url: url, configuration: configuration)
		safariVC.dismissButtonStyle = .close
		
		DispatchQueue.main.async { [weak self] in
			self?.present(safariVC, animated: true, completion: nil)
		}
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
		
		guard isTnCChecked else {
			showAlert(message: "You need to agree our Terms and Conditions")
			return
		}
		
		guard email.isValidEmail() else {
			showAlert(message: "Email format is not valid")
			return
		}
		
		self.view.endEditing(true)
		showLoading()
		service.register(
			firstName: firstName,
			lastName: lastName,
			email: email,
			companyName: companyName,
			companyCountry: companyCountry,
			companyState: companyCity
		) { [weak self] message in
			self?.hideLoading()
			
			let willResentCode = message == "User exists."

			self?.presentOTP(email: email, willResentCode: willResentCode)
		} onFailed: { [weak self] (message) in
			self?.hideLoading()
			self?.showAlert(message: message)
		}
	}
	
	private func presentOTP(email: String, willResentCode: Bool) {
		let inputOTPVC = OTPVerificationViewController()
		inputOTPVC.modalPresentationStyle = .overCurrentContext
		inputOTPVC.email = email
		inputOTPVC.willResentCode = willResentCode
		inputOTPVC.onSuccessVerification = { [weak self] in
			self?.presentServerInformation()
		}
		
		DispatchQueue.main.async { [weak self] in
			self?.navigationController?.pushViewController(inputOTPVC, animated: true)
		}
	}

	private func presentServerInformation() {
		let serverVC = ServerInformationViewController()
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
			  let window = appDelegate.window else {
			return
		}
			
		DispatchQueue.main.async {
			window.rootViewController = serverVC
		}
	}
}

extension RegistrationViewController: UITableViewDelegate {
	
}

extension RegistrationViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		registrationCells.removeAll()
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
		registrationCells.append(cell)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section == 1 {
			let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
			let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
			label.text = "Company Information"
			label.textAlignment = .center
			label.textColor = UIColor(red: 117.0/255.0, green: 117.0/255.0, blue: 117.0/255.0, alpha: 1)
			label.font = UIFont(name: "Helvetica Neue", size: 24)
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
			return 50.0
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
		return getCellTextFieldInput(for: .firstName)
	}
	
	private func getLastNameText() -> String? {
		return getCellTextFieldInput(for: .lastName)
	}
	
	private func getEmailText() -> String? {
		return getCellTextFieldInput(for: .email)
	}
	
	private func getCompanyNameText() -> String? {
		return getCellTextFieldInput(for: .company)
	}
	
	private func getCompanyCountryText() -> String? {
		return getCellTextFieldInput(for: .country)
	}
	
	private func getCompanyCityText() -> String? {
		return getCellTextFieldInput(for: .city)
	}
	
	private func getCellTextFieldInput(for cellType: RegistrationTableViewCell.CellType) -> String? {
		for cell in registrationCells {
			let (type, value) = cell.getValue()
			
			if cellType == type {
				return value
			}
		}
		
		return nil
	}
}
