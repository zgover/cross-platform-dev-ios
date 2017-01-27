//
//  TaskListViewController.swift
//  CrossPlatformDev-iOS
//
//  Created by Zachary Gover on 1/10/17.
//  Copyright © 2017 Zachary Gover. All rights reserved.
//

import UIKit
import Firebase

class TaskListViewController: UITableViewController {

	private var tasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.reloadData()
		// Setup default properties
		//self.navigationItem.rightBarButtonItem = self.editButtonItem
		tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cellIdentifier")

		// Listen for new tasks in the Firebase database
		FirebaseManager.getUserDbTaskReference().queryOrdered(byChild: "createdDate").observe(.childAdded, with: { (snapshot) -> Void in
			self.tasks.append(Task.init(snapshot: snapshot))
			self.tableView.insertRows(at: [IndexPath(row: self.tasks.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
		})
		// Listen for deleted tasks in the Firebase database
		FirebaseManager.getUserDbTaskReference().queryOrdered(byChild: "createdDate").observe(.childRemoved, with: { (snapshot) -> Void in
			let index: Int = self.indexOfMessage(snapshot: snapshot)
			self.tasks.remove(at: index)
			self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: UITableViewRowAnimation.automatic)
		})
		// Listen for edited tasks in the Firebase database
		FirebaseManager.getUserDbTaskReference().queryOrdered(byChild: "createdDate").observe(.childChanged, with: { (snapshot) -> Void in
			let index: Int = self.indexOfMessage(snapshot: snapshot)
			let task: Task = Task.init(snapshot: snapshot)
			self.tasks[index] = task
			self.tableView.reloadData()
		})
		self.tableView.reloadData()

		if (!Network.isConnected()) {
			AppUtils.showAlertNotification(title: "Network Error", message: "Error updating list, please connect to a network.", context: self)
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// Configure the cell
		let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! TableViewCell
		let task: Task = tasks[indexPath.row]

		cell.taskName.text = task.getName() as String
		cell.taskAmount.text = "\(task.getAmount())"
		cell.taskCreatedDate.text = task.getShortCreatedDate()

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
			let alert = UIAlertController(title: "Are you sure?", message: "Are you sure you would like to delete this item?", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
			alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
				FirebaseManager.deleteTask(key: self.tasks[indexPath.row].getKey())
			}))
			self.present(alert, animated: true, completion: nil)
        }
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// Set the method and open the controller
		let task = tasks[indexPath.row]

		FormViewController.method = FormViewController.EDIT
		FormViewController.task = task

		self.performSegue(withIdentifier: "toFormViewController", sender: nil)
	}

	@IBAction func createTask(_ sender: UIBarButtonItem) {
		// Set the method and open the controller
		FormViewController.method = FormViewController.CREATE
		FormViewController.task = nil

		self.performSegue(withIdentifier: "toFormViewController", sender: nil)
	}
	
	@IBAction func logout(_ sender: UIBarButtonItem) {
		FirebaseManager.logout(view: self)
	}

	func indexOfMessage(snapshot: FIRDataSnapshot) -> Int {
		// Loop through the tasks and compare keys
		var index = 0

		for  task in self.tasks {
			if (snapshot.key == task.getKey()) {
				return index
			}
			index += 1
		}

		return -1
	}

}
