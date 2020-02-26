//
//  PriceTableViewCell.swift
//  MBTA
//
//  Created by Abhinav Verma on 17/02/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit

class PriceTableViewCell: UITableViewCell {

    @IBOutlet weak var priceCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
