//
//  MemberProfileCell.swift
//  MBTA
//
//  Created by Ravi on 23/03/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit
import TweeTextField
import iOSDropDown

class MemberProfileCell: UITableViewCell {

    @IBOutlet weak var Edit_btn: UIButton!
    @IBOutlet weak var Member_img: UIImageView!
    
    @IBOutlet weak var Post_lbl: UILabel!
    
    @IBOutlet weak var Address_lbl: UILabel!
    @IBOutlet weak var Phone_lbl: UILabel!
    @IBOutlet weak var Mobile_lbl: UILabel!
    @IBOutlet weak var Email_lbl: UILabel!
    @IBOutlet weak var Designation_lbl: UILabel!
    @IBOutlet weak var Name_lbl: UILabel!
    
    var member: Member? {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        
        self.Address_lbl.text = self.member?.resi_add
        self.Name_lbl.text = self.member?.name
        self.Phone_lbl.text = self.member?.mobile2
        self.Mobile_lbl.text = self.member?.mobile1
        self.Email_lbl.text = self.member?.email
        self.Designation_lbl.text = self.member?.designation
        self.Post_lbl.text = self.member?.post
        
        DispatchQueue.main.async {
            self.Member_img.sd_setImage(with: URL(string: baseURL+(self.member?.photo ?? "")), placeholderImage: #imageLiteral(resourceName: "user"), completed: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
