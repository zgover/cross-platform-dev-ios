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

	static var fbAuth:FIRAuth!
	static var fbDatabase:FIRDatabase!

	public static func getFbAuth() -> FIRAuth {
		if fbAuth.isEqual(nil) {
			fbAuth = FIRAuth.auth()
		}

		return fbAuth
	}

	public static func getFbDatabase() -> FIRDatabase {
		if fbDatabase.isEqual(nil) {
			fbDatabase = FIRDatabase.database()
			fbDatabase.persistenceEnabled = true
		}

		return fbDatabase
	}

}
