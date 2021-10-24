//
//  LaunchViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 10/10/21.
//

import UIKit

class LaunchViewController: UIViewController {
	
	@IBOutlet weak var startButton: UIButton!
	
	@IBAction func startButtonTapped(_ sender: Any) {
		pushToRegister()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		configureView()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationBar()
	}
	
	private func setupNavigationBar() {
		self.setupDefaultNavigationBar()
	}
	
	private func configureView() {
		startButton.layer.cornerRadius = 4
	}
	
	private func pushToRegister() {
		let register = RegistrationViewController()
		DispatchQueue.main.async { [weak self] in
			self?.navigationController?.pushViewController(register, animated: true)
		}
	}
	
	private func pushToLogin() {
		let login = LoginViewController()
		DispatchQueue.main.async { [weak self] in
			self?.navigationController?.pushViewController(login, animated: true)
		}
	}
}
