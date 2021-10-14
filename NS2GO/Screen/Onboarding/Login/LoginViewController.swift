//
//  LoginViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 10/10/21.
//

import UIKit

class LoginViewController: UIViewController {

	
	@IBOutlet var textFieldContainers: [UIView]!
	
	@IBOutlet weak var loginIDTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	
	@IBAction func loginButtonTapped(_ sender: Any) {
		let serverListVC = ServerListViewController()
		let navVC = UINavigationController(rootViewController: serverListVC)
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
			  let window = appDelegate.window else {
			return
		}
		
		window.rootViewController = navVC
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupTextFieldContanier()
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationBar()
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
