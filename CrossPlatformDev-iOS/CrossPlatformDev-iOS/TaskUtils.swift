//
//  TaskUtils.swift
//  CrossPlatformDev-iOS
//
//  Created by Zachary Gover on 1/26/17.
//  Copyright © 2017 Zachary Gover. All rights reserved.
//

import UIKit

class TaskUtils {

	public static func validateName(name: String?) -> String? {
		var msg: String?

		if let _name = name {

			let regex: NSRegularExpression = try! NSRegularExpression(pattern: "^[a-zA-Z0-9]*$", options: [])
			let nsName: NSString = _name as NSString

			// Validate empties and via regex pattern for only numbers and letters
			if _name == "" {
				msg = "Please enter a value for the name"
			} else if regex.numberOfMatches(in: _name, options: [], range: NSMakeRange(0, nsName.length)) == 0 {
				msg = "Please enter only numbers and letters for the name"
			}
		}

		return msg
	}

	public static func validateAmount(amount: String?) -> String? {
		var msg: String?

		if let _amount = amount {
			let regex: NSRegularExpression = try! NSRegularExpression(pattern: "^[0-9]{1,9}$", options: [])
			let nsAmount: NSString = _amount as NSString

			// Validate via regex pattern for only numbers
			if _amount == "" {
				msg = "Please enter a value for the amount"
				return msg;
			} else if regex.numberOfMatches(in: _amount, options: [], range: NSMakeRange(0, nsAmount.length)) == 0 {
				msg = "Please enter a valid number for the amount"
				return msg;
			}

			// Validate value can be parsed into an integer
			if Int(_amount) == nil {
				msg = "Please enter a valid number for the amount"
				return msg
			}
		}

		return msg
	}


	public static func formIsValid(context: UIViewController, nameField: UITextField, amountField: UITextField) -> Bool {
		let nameValidation = TaskUtils.validateName(name: nameField.text)
		let amountValidation = TaskUtils.validateAmount(amount: amountField.text)

		// Validate fields
		if let validation = nameValidation {
			AppUtils.showAlertNotification(title: "Error", message: validation, context: context)
			return false
		}

		if let validation = amountValidation {
			AppUtils.showAlertNotification(title: "Error", message: validation, context: context)
			return false
		}

		return true
	}

	public static func newTask(nameField: UITextField, amountField: UITextField) -> Task {
		let task: Task = Task()
		let name: String = nameField.text!
		let amount: Int = Int(amountField.text!)!
		let createdDate: Int64 = Int64(Date().timeIntervalSince1970 * 1000)

		task.setName(name: name)
		task.setAmount(amount: amount)
		task.setCreatedDate(createdDate: createdDate)

		return task
	}
}























