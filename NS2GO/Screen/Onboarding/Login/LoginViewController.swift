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
		loginButton.layer.cornerRadius = 4
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationBar()
	}
	
	private func setupNavigationBar() {
		self.setupDefaultNavigationBar()
		
		let button = UIButton()
		button.setImage(UIImage(named : "ic_setting"), for: .normal)
		button.setTitle("", for: .normal)
		button.addTarget(self, action: #selector(pushToEditServerInformation), for: .touchUpInside)
		button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
		button.widthAnchor.constraint(equalToConstant: 44).isActive = true
		button.heightAnchor.constraint(equalToConstant: 44).isActive = true
		let btBar = UIBarButtonItem(customView: button)
		self.navigationItem.rightBarButtonItem = btBar
	}
	
	@objc private func pushToEditServerInformation() {
		let lastIndex = (self.navigationController?.viewControllers.count ?? 0) - 1
		if lastIndex > 0,
		   ((self.navigationController?.viewControllers[lastIndex - 1].isKind(of: ServerInformationViewController.self)) != nil)  {
			DispatchQueue.main.async { [weak self] in
				self?.navigationController?.popViewController(animated: true)
			}
		} else {
			let serverVC = ServerInformationViewController()
			self.navigationController?.pushViewController(serverVC, animated: true)
		}
	}
	
	private func setupTextFieldContanier() {
		textFieldContainers.forEach { [weak self] (view) in
			view.layer.borderColor = UIColor.darkGray.cgColor
			view.layer.borderWidth = 1
		}
	}
}
