//
//  FormViewController.swift
//  CrossPlatformDev-iOS
//
//  Created by Zachary Gover on 1/10/17.
//  Copyright © 2017 Zachary Gover. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {

	@IBOutlet weak var nameField: UITextField!
	@IBOutlet weak var amountField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func saveFormResults(_ sender: UIBarButtonItem) {
		if isFormValid() {
			AppUtils.showLoadingScreen(view: self.view)
			// Build the new task from the results
			let task: Task = Task()

			task.setName(name: nameField.text!)
			task.setAmount(amount: Int.init(amountField.text!)!)
			task.setCreatedDate(createdDate: Int64(Date().timeIntervalSince1970 * 1000))

			FirebaseManager.createNewTask(task: task, view: self)
		}
	}

	func isFormValid() -> Bool {
		// Validate all fields for emptys and incorrect data types
		var isValid: Bool = true

		if let name = nameField.text {
			if name.isEmpty {
				isValid = false
			}
		} else {
			isValid = false
		}

		if let amount = amountField.text {
			if amount.isEmpty {
				isValid = false
			} else if (Int.init(amount)) == nil {
				isValid = false
			}
		} else {
			isValid = false
		}

		if !isValid {
			AppUtils.showAlertNotification(title: "Error", message: "Please complete the form", context: self)
		}

		return isValid
	}
}
