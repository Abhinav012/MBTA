//
//  FirmCell.swift
//  MBTA
//
//  Created by Ravi on 18/03/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit

class FirmCell: UITableViewCell {

	@IBOutlet var Firm_logo: UIImageView!
	@IBOutlet var Firm_title: UILabel!
	@IBOutlet var Firm_type: UILabel!
	@IBOutlet var Firm_adress: UILabel!
	@IBOutlet var Firm_id: UILabel!
	@IBOutlet var Link_btn: UIButton!
	
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
