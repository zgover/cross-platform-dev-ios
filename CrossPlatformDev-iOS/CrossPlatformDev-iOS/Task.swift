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
	private var name: NSString!
	private var amount: NSNumber!
	private var createdDate: NSNumber!

	public init() {}

	public init(key: String, name: NSString, amount: NSNumber, createdDate: NSNumber) {
		self.key = key
		self.name = name
		self.amount = amount
		self.createdDate = createdDate
	}

	public init(snapshot: FIRDataSnapshot) {
		self.key = snapshot.key
		self.name = snapshot.childSnapshot(forPath: "name").value as? NSString
		self.amount = snapshot.childSnapshot(forPath: "amount").value as? NSNumber
		self.createdDate = snapshot.childSnapshot(forPath: "createdDate").value as? NSNumber
	}

	public func getKey() -> String {
		return self.key
	}

	public func setKey(key: String) {
		self.key = key
	}

	public func getName() -> NSString {
		return self.name
	}

	public func setName(name: String) {
		self.name = NSString.init(string: name)
	}

	public func getAmount() -> NSNumber {
		return self.amount
	}

	public func setAmount(amount: Int) {
		self.amount = NSNumber.init(value: amount)
	}

	public func getCreatedDate() -> NSNumber {
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
		self.createdDate = NSNumber.init(value: createdDate)
	}

}
