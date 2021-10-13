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
		let register = RegistrationViewController()
		let navVC = UINavigationController(rootViewController: register)
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
			  let window = appDelegate.window else {
			return
		}
		
		DispatchQueue.main.async { [weak self] in
			window.rootViewController = navVC
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		configureView()
    }
	
	private func configureView() {
		startButton.layer.cornerRadius = 4
	}
}
