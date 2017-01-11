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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

		// Setup default properties
		self.navigationItem.rightBarButtonItem = self.editButtonItem
		tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cellIdentifier")

		// Listen for new tasks in the Firebase database
		FirebaseManager.getUserDbTaskReference().observe(.childAdded, with: { (snapshot) -> Void in
			self.tasks.append(Task.init(snapshot: snapshot))
			self.tableView.insertRows(at: [IndexPath(row: self.tasks.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
		})
//		// Listen for deleted tasks in the Firebase database
//		FirebaseManager.getUserDbTaskReference().observe(.childRemoved, with: { (snapshot) -> Void in
//			let index: Int = self.indexOfMessage(snapshot)
//			self.tasks.remove(at: index)
//			self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: UITableViewRowAnimation.automatic)
//		})
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
		// Configure the cell...
		let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! TableViewCell
		let task: Task = tasks[indexPath.row]

		cell.taskName.text = task.getName()
		cell.taskAmount.text = "\(task.getAmount())"
		cell.taskCreatedDate.text = task.getShortCreatedDate()

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
