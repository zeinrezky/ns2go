//
//  PopupNodeMenuViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 26/10/21.
//

import UIKit

class PopupNodeMenuViewController: UIViewController {
	
	var onTapViewAlertDef: (() -> Void)?
	var onTapLogout: (() -> Void)?
	
	@IBOutlet weak var btViewAlert: UIButton!
	@IBOutlet weak var btLogout: UIButton!
	
	@IBAction func didTapAlertDef(_ sender: Any) {
		DispatchQueue.main.async { [weak self] in
			self?.dismiss(animated: true, completion: nil)
		}
		self.onTapViewAlertDef?()
	}
	
	@IBAction func didTapLogout(_ sender: Any) {
		DispatchQueue.main.async { [weak self] in
			self?.dismiss(animated: true, completion: nil)
		}
		self.onTapLogout?()
	}
	
	@IBAction func didTapDismissArea(_ sender: Any) {
		DispatchQueue.main.async { [weak self] in
			self?.dismiss(animated: true, completion: nil)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		btViewAlert.layer.borderWidth = 1
		btViewAlert.layer.borderColor = UIColor.black.cgColor
		
		btLogout.layer.borderWidth = 1
		btLogout.layer.borderColor = UIColor.black.cgColor
    }

}
