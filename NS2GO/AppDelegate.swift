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
		
		let initialVC = LaunchViewController()
		let navVC = UINavigationController(rootViewController: initialVC)
		
		self.window?.rootViewController = navVC
		self.window?.makeKeyAndVisible()
		
		return true
	}

}

