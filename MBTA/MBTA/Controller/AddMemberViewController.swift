//
//  AddMemberViewController.swift
//  MBTA
//
//  Created by Ravi on 24/03/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit
import iOSDropDown
import TweeTextField
import JGProgressHUD

protocol AddMemberDelegate: class {
    func newMemberAdded()
    func memberDidUpdated()
}

class AddMemberViewController: UIViewController {

    var imagePicker: ImagePicker!
    var hud = JGProgressHUD(style: .dark)
    
    @IBOutlet weak var ContentV_view: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var Logo_view: UIImageView!
    @IBOutlet weak var Post_txt: TweeAttributedTextField!
    @IBOutlet weak var Address_txt: TweeAttributedTextField!
    @IBOutlet weak var Mobile2_txt: TweeAttributedTextField!
    @IBOutlet weak var Mobile1_txt: TweeAttributedTextField!
    @IBOutlet weak var Email_txt: TweeAttributedTextField!
    @IBOutlet weak var Designation_dropdown: DropDown!
    @IBOutlet weak var Name_txt: TweeAttributedTextField!
    
    var member : Member?
    var isNewMember = false
    let designations = ["Chairman","Director","Proprietor","Partner"]
    
    var delegate: AddMemberDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Name_txt.text = member?.name
        self.Email_txt.text = member?.email
        self.Address_txt.text = member?.resi_add
        self.Post_txt.text = member?.post
        self.Mobile1_txt.text = member?.mobile1
        self.Mobile2_txt.text = member?.mobile2
        
        self.Designation_dropdown.listHeight = self.view.frame.height*2
        self.Designation_dropdown.optionArray = self.designations
        self.Designation_dropdown.selectedRowColor = .lightGray
        
        self.Designation_dropdown.text = self.member?.designation
        
        self.Designation_dropdown.didSelect{(selectedText , index ,id) in
            self.Designation_dropdown.text = selectedText
        }
        
        if self.member == nil {
            self.Designation_dropdown.text = "Select Designation"
        }
        
        DispatchQueue.main.async {
            self.Logo_view.sd_setImage(with: URL(string: baseURL+(self.member?.photo ?? "")), placeholderImage: #imageLiteral(resourceName: "user"), completed: nil)
        }
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    @IBAction func Save_Tapped(_ sender: UIButton) {
        
        hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        hud.vibrancyEnabled = true
        hud.textLabel.text = "Loading"
        hud.show(in: self.view, animated: true)
        
        
        var id: String?
        
        if let data = UserDefaults.standard.value(forKey:"user@MBTA") as? Data {
            let user = try? PropertyListDecoder().decode(User.self, from: data)
            id = user?.userid
            
            let toRemove = "mbta"
            if let range = id?.range(of: toRemove) {
               id?.removeSubrange(range)
            }
        }
        
        guard let userId = id else {
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.textLabel.text = "Somethig Wrong !!!"
            hud.dismiss(afterDelay: 2.0)
            
            return
        }

        if isNewMember {
            
            let params: [String : Any] = ["memberid": userId,
                                          "name":self.Name_txt.text ?? "",
                                          "mobile1":self.Mobile1_txt.text ?? "",
                                          "mobile2":self.Mobile2_txt.text ?? "",
                                          "email":self.Email_txt.text ?? "",
                                          "address": self.Address_txt.text ?? "",
                                          "resi_add": self.Address_txt.text ?? "",
                                          "photo": "",
                                          "designation":self.Designation_dropdown.text ?? "",
                                          "post":self.Post_txt.text ?? ""]
            
            
            APIManager.manager.addNewMember(for: params) { (success, error) in
                
                DispatchQueue.main.async {
                    guard let error = error else {
                        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        self.hud.textLabel.text = "Added"
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
                            if let delegate = self.delegate {
                                delegate.newMemberAdded()
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                        self.hud.dismiss(afterDelay: 2)
                        return
                    }
                    print(error.localizedDescription)
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.textLabel.text = "Try Letter !!!"
                    self.hud.dismiss(afterDelay: 2.0)
                    
                }
            }
        } else {
            
            let params: [String : Any] = ["memberid": userId,
                                          "id":self.member?.senderid ?? "",
                                          "name":self.Name_txt.text ?? "",
                                          "mobile1":self.Mobile1_txt.text ?? "",
                                          "mobile2":self.Mobile2_txt.text ?? "",
                                          "email":self.Email_txt.text ?? "",
                                          "address": self.Address_txt.text ?? "",
                                          "resi_add": self.Address_txt.text ?? "",
                                          "photo": "",
                                          "designation":self.Designation_dropdown.text ?? "",
                                          "post":self.Post_txt.text ?? ""]
            
            
            APIManager.manager.updateMember(for: params) { (success, error) in
                
                DispatchQueue.main.async {
                    guard let error = error else {
                        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        self.hud.textLabel.text = "Updated"
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
                            if let delegate = self.delegate {
                                delegate.memberDidUpdated()
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                        self.hud.dismiss(afterDelay: 2)
                        return
                    }
                    print(error.localizedDescription)
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.textLabel.text = "Try Letter !!!"
                    self.hud.dismiss(afterDelay: 2.0)
                    
                }
            }
            
        }
        
    }
    
    @IBAction func Camera_Tapped(_ sender: UIButton) {
         self.imagePicker.present(from: sender)
    }
    
}

extension AddMemberViewController: ImagePickerDelegate , UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }

    func didSelect(image: UIImage?) {
        self.Logo_view.image = image
    }
}
