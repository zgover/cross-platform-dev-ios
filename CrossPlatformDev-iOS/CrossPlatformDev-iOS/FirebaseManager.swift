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

	public static func getFbAuth() -> FIRAuth {
		if fbAuth == nil {
			fbAuth = FIRAuth.auth()
		}

		return fbAuth
	}

	public static func getFbDatabase() -> FIRDatabase {
		if fbDatabase == nil {
			fbDatabase = FIRDatabase.database()
			fbDatabase.persistenceEnabled = true
		}

		return fbDatabase
	}

	public static func logout() -> Bool {
		do {
			try getFbAuth().signOut()
			return true
		} catch let signOutError as NSError {
			print(TAG + ":logout: " + signOutError.debugDescription)
			return false
		}
	}

}
