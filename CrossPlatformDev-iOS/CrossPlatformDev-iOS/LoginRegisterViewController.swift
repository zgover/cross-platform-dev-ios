//
//  ViewController.swift
//  CrossPlatformDev-iOS
//
//  Created by Zachary Gover on 1/9/17.
//  Copyright © 2017 Zachary Gover. All rights reserved.
//

import UIKit
import Firebase

class LoginRegisterViewController: UIViewController {

	private static let TAG = "LoginRegisterViewController"

	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

		if FirebaseManager.getFbAuth().currentUser != nil {
			// User is signed in proceed to next screen
			openTaskListView()
		}

		FirebaseManager.getFbAuth().addStateDidChangeListener({ (auth, user) in
			if user != nil {
				// Auto login
				self.openTaskListView()
			}
		})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func loginButtonPressed(_ sender: UIButton) {
		if formIsValid() {
			AppUtils.showLoadingScreen(view: self.view)

			// Try logging in the user if the form is valid
			FirebaseManager.getFbAuth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
				self.signIn(user: user, error: error)
			}
		}
	}

	@IBAction func registerButtonPressed(_ sender: UIButton) {
		if formIsValid() {
			AppUtils.showLoadingScreen(view: self.view)

			// Try creating a new user if the form is valid
			FirebaseManager.getFbAuth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
				self.signIn(user: user, error: error)
			}
		}
	}

	private func signIn(user: NSObject?, error: Error?) {
		// If there is in error notify the user otherwise proceed to the next screen
		AppUtils.closeLoadingScreen()

		if error != nil {
			AppUtils.showAlertNotification(title: "Error", message: "There was an error logging in.", context: self)
			print(LoginRegisterViewController.TAG + ":signIn: " + error.debugDescription)
			return
		} else if user != nil {
			openTaskListView()
		}
	}

	private func openTaskListView() {
		self.performSegue(withIdentifier: "toTaskListViewController", sender: nil)
	}

	private func formIsValid() -> Bool {
		var isValid = true

		// Check fields for empties
		if let email = emailField.text {
			if email.isEmpty {
				isValid = false
			}
		} else {
			isValid = false
		}

		if let password = passwordField.text {
			if password.isEmpty {
				isValid = false
			}
		} else {
			isValid = false
		}

		if !isValid {
			AppUtils.showAlertNotification(title: "Finish", message: "Please complete the form", context: self)
		}

		return isValid
	}
}

