//
//  NotificationCell.swift
//  MBTA
//
//  Created by Ravi on 06/03/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var Base_view: UIView!
    @IBOutlet weak var Description_lbl: UILabel!
    @IBOutlet weak var Header_lbl: UILabel!
    @IBOutlet weak var SubTitle_lbl: UILabel!
    @IBOutlet weak var Title_lbl: UILabel!
    @IBOutlet weak var Date_lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
