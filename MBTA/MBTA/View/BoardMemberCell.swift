//
//  BoardMemberCell.swift
//  MBTA
//
//  Created by Ravi on 30/03/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit

class BoardMemberCell: UICollectionViewCell {
    @IBOutlet weak var Member_img: UIImageView!
    
    @IBOutlet weak var Member_Firm: UILabel!
    @IBOutlet weak var Member_name: UILabel!
}


class BoardHeaderCell : UICollectionViewCell {
    
    @IBOutlet weak var Title: UILabel!
    
}
