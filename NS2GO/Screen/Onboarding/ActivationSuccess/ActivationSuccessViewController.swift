//
//  ActivationSuccessViewController.swift
//  NS2GO
//
//  Created by Yosua Antonio Raphael Ekowidjaja on 10/10/21.
//

import UIKit

class ActivationSuccessViewController: UIViewController {
	
	var onSuccessVerification: (() -> Void)?
	
	@IBOutlet weak var continueButton: UIButton!
	
	@IBAction func continueButtonTapped(_ sender: Any) {
		DispatchQueue.main.async { [weak self] in
			self?.dismiss(animated: true, completion: nil)
		}
		onSuccessVerification?()
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
