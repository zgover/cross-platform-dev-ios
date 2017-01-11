//
//  FirebaseManager.swift
//  CrossPlatformDev-iOS
//
//  Created by Zachary Gover on 1/9/17.
//  Copyright © 2017 Zachary Gover. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class FirebaseManager {

	private static var TAG = "FirebaseManager";

	private static var fbAuth:FIRAuth!
	private static var fbDatabase:FIRDatabase!
	private static var fbDbReference:FIRDatabaseReference!

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

	public static func getUserTasksQuery() {
		// Build query to fetch only the current users tasks
		let tasks: FIRDatabaseQuery = getFbDbReference().child(getUserId()).child(<#T##pathString: String##String#>)
	}

	public static func getUserId() -> String {
		return getFbAuth().currentUser!.uid
	}

	public static func logout() -> Bool {
		// Try to sign out of the Firebase account and return result
		do {
			try getFbAuth().signOut()
			return true
		} catch let signOutError as NSError {
			print(TAG + ":logout: " + signOutError.debugDescription)
			return false
		}
	}

}
