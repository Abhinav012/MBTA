//
//  MemberCell.swift
//  MBTA
//
//  Created by AllSpark on 19/03/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {

	@IBOutlet var Member_adress: UILabel!
	@IBOutlet var Member_email: UILabel!
	@IBOutlet var Member_phone2: UILabel!
	@IBOutlet var Member_phone1: UILabel!
	@IBOutlet var Member_position: UILabel!
	@IBOutlet var Member_name: UILabel!
	@IBOutlet var Member_logo: UIImageView!
	
	@IBOutlet var Chat_btn: UIButton!
	@IBOutlet var Mail_btn: UIButton!
	@IBOutlet var Whatsapp_btn: UIButton!
	@IBOutlet var Call_btn: UIButton!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
