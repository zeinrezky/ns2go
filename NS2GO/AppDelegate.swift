//
//  AppDelegate.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 09/10/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		self.window = UIWindow(frame: UIScreen.main.bounds)
		
		BaseURL.shared.loadIPServer()
		let isUserRegistered = UserDefaults.standard.bool(forKey: NS2GOConstant.KeyUserRegistered)
		let initialVC: UIViewController
		if isUserRegistered {
			initialVC = LoginViewController()
		} else {
			initialVC = LaunchViewController()
		}
		
		let navVC = UINavigationController(rootViewController: initialVC)
		
		if let font = UIFont(name: "HelveticaNeue", size: 20) {
			navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font]
		}
		
		self.window?.rootViewController = navVC
		self.window?.makeKeyAndVisible()
		
		return true
	}
	
	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		return .portrait
	}

}

