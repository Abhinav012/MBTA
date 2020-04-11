//
//  FirmProfileCell.swift
//  MBTA
//
//  Created by Ravi on 23/03/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit
import TweeTextField
import iOSDropDown
import TTGTagCollectionView
import SDWebImage

protocol FirmProfileDelegate: class {
    func needUpdateView(for editing : Bool)
    func needUpdateFirm(with data: [String: Any])
}

class FirmProfileCell: UITableViewCell , TTGTextTagCollectionViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var DropDown_view: UIView!
    @IBOutlet weak var Save_HC: NSLayoutConstraint!
    @IBOutlet weak var Edit_btn: UIButton!
    @IBOutlet weak var Bazar_lbl: UILabel!
    @IBOutlet weak var Save_btn: UIButton!
    
    @IBOutlet weak var Firm_natureView: TTGTextTagCollectionView!
    @IBOutlet weak var Firm_url: TweeAttributedTextField!
    @IBOutlet weak var Firm_adressLbl: UILabel!
    @IBOutlet weak var Bazar_dropdown: DropDown!
    @IBOutlet weak var Firm_address: TweeAttributedTextField!
    @IBOutlet weak var Firm_name: UILabel!
    @IBOutlet weak var Firm_id: UILabel!
    @IBOutlet weak var Firm_logo: UIImageView!
    
    var imagePicker: ImagePicker!
    
    let natures = ["Retail","Manufacturer","Whole Seller","Silver","Gold","Diamond"]
    let bazars = ["Valley Bazar Sarrafa","Sarrafa Bazar","Neel Gali Sarrafa","Kagzi Bazar Sarrafa","Sadar Sarrafa","Abu Lane Sarrafa", "Begumpul Sarrafa","Sahaghasa Sarrafa", "Railway Road Sarrafa","Garh Road", "Lal Kurti", "Shashtri Nagar", "Kankar Khera", "Suraj Kund Road"]
    
    var firm_natures = [String]()
    
    var delegate: FirmProfileDelegate?
    public var vc : UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var firm: FirmProfile! {
        didSet {
            self.imagePicker = ImagePicker(presentationController: self.vc!, delegate: self)
            self.updateUI()
        }
    }
    
    func updateUI() {
        self.Firm_id.text = (self.firm.member_id ?? "").formaeID()
        self.Firm_name.text = self.firm?.f_name ?? "--"
        self.Firm_address.text = self.firm?.f_add ?? "--"
        self.Firm_address.delegate = self
        self.Firm_adressLbl.text = self.firm?.f_add ?? "--"
        self.Firm_url.text = self.firm?.f_url ?? "--"
        self.Firm_url.delegate = self
        self.Bazar_lbl.text = self.firm.bazar ?? "--"
        self.firm_natures = (self.firm.nature ?? "").components(separatedBy: ",")
        
        self.DropDown_view.isHidden = self.Edit_btn.tag == 0 ? true : false
        
        self.Bazar_dropdown.listHeight = self.frame.height*2
        self.Bazar_dropdown.optionArray = self.bazars
        self.Bazar_dropdown.selectedRowColor = .lightGray
        
        self.Bazar_dropdown.didSelect{(selectedText , index ,id) in
            self.Bazar_dropdown.text = selectedText
        }
        self.Bazar_dropdown.text = "Select Bazar"
        
        self.Firm_natureView?.delegate = self
        self.Firm_natureView.showsVerticalScrollIndicator = false
        self.Firm_natureView.showsHorizontalScrollIndicator = false
        let config = self.Firm_natureView.defaultConfig
        
        config?.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        config?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        config?.cornerRadius = 5
        config?.selectedBackgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        config?.selectedTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.reloadNatures()
        DispatchQueue.main.async {
            self.Firm_logo.sd_setImage(with: URL(string: baseURL+(self.firm.f_logo ?? "")), placeholderImage: #imageLiteral(resourceName: "appLogo"), completed: nil)
        }
        
    }
    
    func reloadNatures (){
        
        self.Edit_btn.setTitle(Edit_btn.tag == 0 ? "Edit" : "Cancel", for: .normal
        )
        self.Save_btn.setTitle(Edit_btn.tag == 0 ? nil : "Save", for: .normal
        )
        self.Save_HC.constant = Edit_btn.tag == 0 ? 0 : 40
        UIView.animate(withDuration: 0.3) {
            self.contentView.layoutIfNeeded()
        }
        
        self.Firm_adressLbl.isHidden = (self.Edit_btn.tag == 1) ? true : false
        self.Bazar_dropdown.isHidden = (self.Edit_btn.tag == 0) ? true : false
        self.Bazar_lbl.isHidden = (self.Edit_btn.tag == 1) ? true : false
        
        if self.Edit_btn.tag == 0 && self.firm_natures.count > 0 {
        if self.Firm_natureView.allTags().count != self.firm_natures.count {
            self.Firm_natureView.removeAllTags()
            self.Firm_natureView.addTags( self.firm_natures )
            for i in 0...self.firm_natures.count-1 {
                self.Firm_natureView.setTagAt(UInt(i), selected: true)
            }
        }
        } else {
            if self.Firm_natureView.allTags().count != self.natures.count {
                self.Firm_natureView.removeAllTags()
                self.Firm_natureView.addTags( self.natures )
                for i in 0...self.natures.count-1 {
                    let nature = self.natures[i]
                    self.Firm_natureView.setTagAt(UInt(i), selected: self.firm_natures.contains(nature))
                }
            }
        }
        self.Firm_natureView.reload()
    }
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        
        if self.Edit_btn.tag == 0 {
            self.Firm_natureView.setTagAt(index, selected: true)
            return
        }
        
        if selected {
            self.firm_natures.insert(tagText, at: 0)
        } else {
            if let index = self.firm_natures.firstIndex(of: tagText) {
                self.firm_natures.remove(at: index)
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return self.Edit_btn.tag == 1
    }
    
    @IBAction func Edit_Tapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            if let delegate = self.delegate {
                delegate.needUpdateView(for: sender.tag == 0 )
            }
        }
    }
    
    
    @IBAction func Save_Tapped(_ sender: UIButton) {
        
        var id: String?
        
        if let data = UserDefaults.standard.value(forKey:"user@MBTA") as? Data {
            let user = try? PropertyListDecoder().decode(User.self, from: data)
            id = user?.userid
            
            let toRemove = "mbta"
            if let range = id?.range(of: toRemove) {
               id?.removeSubrange(range)
            }
        }
        
        let bazar = self.Bazar_dropdown.text == "Selecte Bazar" ? "" : self.Bazar_dropdown.text!
        
        var udpatedNatures = ""
        
        for item in self.Firm_natureView.allSelectedTags(){
            if self.Firm_natureView.allSelectedTags()?.last == item {
                udpatedNatures = udpatedNatures + item
            } else {
                udpatedNatures = udpatedNatures + item + ","
            }
        }
        
        
        let params: [String: Any] = ["id": id ?? "",
                      "f_name": Firm_name.text ?? "",
                      "f_add": self.Firm_address.text ?? "",
                      "f_logo": self.Firm_logo.image?.pixelData() as Any,
                      "f_url": self.Firm_url.text ?? "",
                      "bazar": bazar,
                      "nature": udpatedNatures]
        
        DispatchQueue.main.async {
            if let delegate = self.delegate {
                delegate.needUpdateFirm(with: params)
            }
        }
        
    }
    
    @IBAction func Camera_Tapped(_ sender: Any) {
        guard self.Edit_btn.tag == 1 else {
            return
        }
        
        self.imagePicker.present(from: sender as! UIButton)
    }
}

extension FirmProfileCell: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.Firm_logo.image = image
    }
}
