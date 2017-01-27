//
//  FormViewController.swift
//  CrossPlatformDev-iOS
//
//  Created by Zachary Gover on 1/10/17.
//  Copyright © 2017 Zachary Gover. All rights reserved.
//

import UIKit

class FormViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var nameField: UITextField!
	@IBOutlet weak var amountField: UITextField!

	public static var method: Int!
	public static var CREATE: Int = 1
	public static var EDIT: Int = 2
	public static var task: Task?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		if FormViewController.method == FormViewController.EDIT {
			self.title = "Edit Task"
			nameField.text = FormViewController.task!.getName() as String
			amountField.text = FormViewController.task!.getAmount().stringValue
		} else {
			self.title = "Create Task"
			nameField.text = ""
			nameField.text = ""
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func saveFormResults(_ sender: UIBarButtonItem) {
		if (!Network.isConnected()) {
			AppUtils.showAlertNotification(title: "Network Error", message: "Please connect to a network", context: self)
			return
		}

		if TaskUtils.formIsValid(context: self, nameField: nameField, amountField: amountField) {
			AppUtils.showLoadingScreen(view: self.view)
			
			if FormViewController.method == FormViewController.EDIT {
				// Update values and push to Firebase
				FormViewController.task!.setName(name: nameField.text!)
				FormViewController.task!.setAmount(amount: Int(amountField.text!)!)
				FirebaseManager.saveTask(task: FormViewController.task!, view: self)
			} else {
				// Build the new task from the results
				let task: Task = TaskUtils.newTask(nameField: nameField, amountField: amountField)

				FirebaseManager.createNewTask(task: task, view: self)
			}
		}
	}

	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

		if let text = textField.text {
			let cnt = text.characters.count + string.characters.count - range.length
			return cnt <= 9
		}

		return true
	}
}
