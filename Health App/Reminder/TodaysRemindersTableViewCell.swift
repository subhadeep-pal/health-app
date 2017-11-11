//
//  TodaysRemindersTableViewCell.swift
//  Health App
//
//  Created by Koushik Dutta on 08/11/17.
//  Copyright © 2017 Virtual Elf LLC. All rights reserved.
//

import UIKit

class TodaysRemindersTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBoxView: CheckBox!
    @IBOutlet weak var reminderTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
