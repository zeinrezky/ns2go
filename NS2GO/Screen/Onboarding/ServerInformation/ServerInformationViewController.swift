//
//  ServerInformationViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 10/10/21.
//

import UIKit

class ServerInformationViewController: UIViewController {
	
	@IBOutlet var textFieldContainers: [UIView]!
	
	@IBOutlet weak var ipAddressTextField: UITextField!
	@IBOutlet weak var portTextField: UITextField!
	@IBOutlet weak var saveButton: UIButton!
	
	@IBAction func saveButtonTapped(_ sender: Any) {
		let loginVC = LoginViewController()
		DispatchQueue.main.async { [weak self] in
			self?.navigationController?.pushViewController(loginVC, animated: true)
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationBar()
	}
	
	private func setupView() {
		saveButton.layer.cornerRadius = 4
		setupTextFieldContanier()
	}
	
	private func setupNavigationBar() {
		self.setupDefaultNavigationBar()
	}
	
	private func setupTextFieldContanier() {
		textFieldContainers.forEach { [weak self] (view) in
			view.layer.borderColor = UIColor.darkGray.cgColor
			view.layer.borderWidth = 1
		}
	}

}
