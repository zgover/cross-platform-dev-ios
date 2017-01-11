//
//  TableViewCell.swift
//  CrossPlatformDev-iOS
//
//  Created by Zachary Gover on 1/10/17.
//  Copyright © 2017 Zachary Gover. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

	@IBOutlet weak var taskName: UILabel!
	@IBOutlet weak var taskAmount: UILabel!
	@IBOutlet weak var taskCreatedDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
