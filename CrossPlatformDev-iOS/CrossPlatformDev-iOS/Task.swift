//
//  Task.swift
//  CrossPlatformDev-iOS
//
//  Created by Zachary Gover on 1/10/17.
//  Copyright © 2017 Zachary Gover. All rights reserved.
//

import Foundation
import Firebase

class Task {

	public static let OBJECT_NAME: String = "tasks"

	private var key: String!
	private var name: String!
	private var amount: Int!
	private var createdDate: Int64!

	public init() {}

	public init(key: String, name: String, amount: Int, createdDate: Int64) {
		self.key = key
		self.name = name
		self.amount = amount
		self.createdDate = createdDate
	}

	public init(snapshot: FIRDataSnapshot) {
		self.key = snapshot.key
		self.name = snapshot.childSnapshot(forPath: "name").value as? String
		self.amount = snapshot.childSnapshot(forPath: "amount").value as? Int
		self.createdDate = snapshot.childSnapshot(forPath: "createdDate").value as? Int64
	}

	public func getKey() -> String {
		return self.key
	}

	public func setKey(key: String) {
		self.key = key
	}

	public func getName() -> String {
		return self.name
	}

	public func setName(name: String) {
		self.name = name
	}

	public func getAmount() -> Int {
		return self.amount
	}

	public func setAmount(amount: Int) {
		self.amount = amount
	}

	public func getCreatedDate() -> Int64 {
		return self.createdDate
	}

	public func getShortCreatedDate() -> String {
		// Convert, format and return
		let time: NSDate = NSDate(timeIntervalSince1970: TimeInterval(createdDate)/1000.0)
		let formatter = DateFormatter()
		formatter.dateFormat = "MM/YY"

		return formatter.string(from: time as Date)
	}

	public func setCreatedDate(createdDate: Int64) {
		self.createdDate = createdDate
	}

}
