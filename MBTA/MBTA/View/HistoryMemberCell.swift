//
//  HistoryMemberCell.swift
//  MBTA
//
//  Created by Ravi on 06/04/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit

class HistoryMemberCell: UITableViewCell {

    
    @IBOutlet weak var Member_Post_lbl: UILabel!
    
    @IBOutlet weak var Member_Name_lbl: UILabel!
    @IBOutlet weak var Member_logo_img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
