//
//  LaunchViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 10/10/21.
//

import UIKit

class LaunchViewController: UIViewController {
	
	@IBOutlet weak var blurView: UIView!
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
		self.navigationController?.setNavigationBarHidden(true, animated: false)
	}
	
	private func setupNavigationBar() {
		self.setupDefaultNavigationBar()
		self.navigationController?.interactivePopGestureRecognizer?.delegate = self
	}
	
	private func configureView() {
		startButton.layer.cornerRadius = 4
		addGradientLayer()
	}
	
	private func addGradientLayer() {
		let gradientLayer = CAGradientLayer()
		let blueColor = UIColor(red: 208.0/255.0, green: 228.0/255.0, blue: 253.0/255.0, alpha: 1)
		gradientLayer.colors = [blueColor.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, blueColor.cgColor]
		gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
		gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
		gradientLayer.locations = [NSNumber(value: 0.0), NSNumber(value: 0.2), NSNumber(value: 0.5), NSNumber(value: 1)]
		gradientLayer.frame = blurView.frame
		blurView.layer.addSublayer(gradientLayer)
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

extension LaunchViewController: UIGestureRecognizerDelegate {
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		guard let nav = navigationController else {
			return false
		}
		
		return nav.viewControllers.count > 1
	}
}
