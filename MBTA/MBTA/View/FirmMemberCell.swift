//
//  FirmMemberCell.swift
//  MBTA
//
//  Created by Ravi on 18/03/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit

class FirmMemberCell: UITableViewCell {

	@IBOutlet var Member_name: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
