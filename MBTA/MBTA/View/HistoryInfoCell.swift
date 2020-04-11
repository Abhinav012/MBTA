//
//  VisionInfoCell.swift
//  MBTA
//
//  Created by Ravi on 06/04/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit

class HistoryInfoCell: UITableViewCell {

    @IBOutlet weak var Title_lbl: UILabel!
    @IBOutlet weak var Info_lbl: UILabel!
    
    
    @IBOutlet weak var M1_Name_lbl: UILabel!
    @IBOutlet weak var M1_Logo_img: UIImageView!
    @IBOutlet weak var M1_Post_lbl: UILabel!
    
    @IBOutlet weak var M2_Name_lbl: UILabel!
    @IBOutlet weak var M2_Logo_img: UIImageView!
    @IBOutlet weak var M2_Post_lbl: UILabel!
    
    @IBOutlet weak var M3_Name_lbl: UILabel!
    @IBOutlet weak var M3_Logo_img: UIImageView!
    @IBOutlet weak var M3_Post_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
