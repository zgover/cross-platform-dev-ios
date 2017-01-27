//
//  FirebaseManager.swift
//  CrossPlatformDev-iOS
//
//  Created by Zachary Gover on 1/9/17.
//  Copyright © 2017 Zachary Gover. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FirebaseManager {

	private static var TAG = "FirebaseManager";

	private static var fbAuth:FIRAuth!
	private static var fbDatabase:FIRDatabase!
	private static var fbDbReference:FIRDatabaseReference!
	private static var fbUserDbTaskReference:FIRDatabaseReference!

	public static func destroy() {
		//fbDatabase.goOffline()
		fbAuth = nil
		//fbDatabase = nil
		//fbDbReference = nil
		fbUserDbTaskReference = nil
	}

	public static func getFbAuth() -> FIRAuth {
		// Return and/or create the auth instance
		if fbAuth == nil {
			fbAuth = FIRAuth.auth()
		}

		return fbAuth
	}

	public static func getFbDatabase() -> FIRDatabase {
		// Return and/or create the database instance
		if fbDatabase == nil {
			fbDatabase = FIRDatabase.database()
			fbDatabase.persistenceEnabled = true
		}

		return fbDatabase
	}

	public static func getFbDbReference() -> FIRDatabaseReference {
		// Return and/or create database reference
		if fbDbReference == nil {
			fbDbReference = getFbDatabase().reference()
		}

		return fbDbReference
	}

	public static func getUserDbTaskReference() -> FIRDatabaseReference {
		// Return and/or create db reference
		if fbUserDbTaskReference == nil {
			fbUserDbTaskReference = getFbDbReference().child(getUserId()).child(Task.OBJECT_NAME)
		}

		return fbUserDbTaskReference
	}

	public static func getUserTasksQuery() -> FIRDatabaseQuery {
		// Build query to fetch only the current users tasks
		let tasks: FIRDatabaseQuery = getFbDbReference().child(getUserId())
			.child(Task.OBJECT_NAME).queryOrdered(byChild: "createdDate")
		return tasks
	}

	public static func deleteTask(key: String) {
		getFbDbReference().child(getUserId()).child(Task.OBJECT_NAME).child(key).removeValue()
	}

	public static func getUserId() -> String {
		return getFbAuth().currentUser!.uid
	}

	public static func logout(view: UIViewController) {
		// Try to sign out of the Firebase account and present login/register view controller
		do {
			try getFbAuth().signOut()
//			let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//			let vc: UIViewController = mainStoryboard.instantiateInitialViewController() as! LoginRegisterViewController
			destroy()
			view.dismiss(animated: true, completion: nil)
			view.navigationController!.dismiss(animated: true, completion: nil)
			//view.present(vc, animated: true, completion: nil)
		} catch let signOutError as NSError {
			print(TAG + ":logout: " + signOutError.debugDescription)
			AppUtils.showAlertNotification(title: "Error", message: "There was an error logging out", context: view)
		}
	}

	public static func createNewTask(task: Task, view: UIViewController) {
		// Push to get a new key, assign  the values and update the children
		let ref: FIRDatabaseReference = getFbDbReference().child(getUserId())
			.child(Task.OBJECT_NAME).childByAutoId()

		ref.updateChildValues([NSString.init(string: "name") : task.getName(),
		                       NSString.init(string: "amount") : task.getAmount(),
		                       NSString.init(string: "createdDate") : task.getCreatedDate()]) { (error, dbRef) in
			if error != nil {
				print(TAG + ":createNewTask:updateChildValues: " + error.debugDescription)
				AppUtils.showAlertNotification(title: "Error", message: "There was an error creating the task", context: view)
				return
			}

			AppUtils.closeLoadingScreen()
			//AppUtils.showAlertNotification(title: "Success", message: "The task has been created successfully", context: view)
			view.navigationController!.popViewController(animated: true)
		}
	}

	public static func saveTask(task: Task, view: UIViewController) {
		// Push to get a new key, assign  the values and update the children
		let ref: FIRDatabaseReference = getFbDbReference().child(getUserId())
			.child(Task.OBJECT_NAME).child(task.getKey())

		ref.updateChildValues([NSString.init(string: "name") : task.getName(),
		                       NSString.init(string: "amount") : task.getAmount(),
		                       NSString.init(string: "createdDate") : task.getCreatedDate()]) { (error, dbRef) in
			if error != nil {
				print(TAG + ":saveTask:updateChildValues: " + error.debugDescription)
				AppUtils.closeLoadingScreen()
				AppUtils.showAlertNotification(title: "Error", message: "There was an error saving the task", context: view)
				return
			}

			AppUtils.closeLoadingScreen()
			//AppUtils.showAlertNotification(title: "Success", message: "The task has been created successfully", context: view)

			if let controller = view as? FormViewController {
				controller.nameField.text = ""
				controller.amountField.text = ""
				FormViewController.method = FormViewController.CREATE
				FormViewController.task = nil
			}

			view.navigationController!.popViewController(animated: true)
		}
	}

}
