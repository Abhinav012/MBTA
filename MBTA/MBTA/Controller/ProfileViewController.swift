//
//  ProfileViewController.swift
//  MBTA
//
//  Created by Ravi on 23/03/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit
import JGProgressHUD

class ProfileViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{

    var firm: FirmProfile?
    var members: [Member]?
    var firmID: String?
    
    var flotingAddBtn = UIButton()
    
    var isEditingFirm = false
    
    var hud = JGProgressHUD(style: .dark)
    
    @IBOutlet weak var Profile_tbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = UserDefaults.standard.value(forKey:"user@MBTA") as? Data {
            let user = try? PropertyListDecoder().decode(User.self, from: data)
            
            firmID = user?.userid
            
            let toRemove = "mbta"
            if let range = firmID?.range(of: toRemove) {
               firmID?.removeSubrange(range)
            }
        }
        self.setupFloatingButton()
        self.Profile_tbl.delegate = self
        self.Profile_tbl.dataSource = self
        self.Profile_tbl.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.flotingAddBtn.alpha = 1
        self.fetchProfile()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.flotingAddBtn.alpha = 0
    }
    
    func fetchProfile() {
        
        APIManager.manager.getuserProfile { (model, error) in
            
            guard let model = model else {
                self.dismiss(animated: true, completion: nil)
                return
            }
            
            self.firm = model.firm
            self.members = model.member
            
            guard self.firm != nil else {
                self.dismiss(animated: true, completion: nil)
                return
            }
            
            DispatchQueue.main.async {
                self.Profile_tbl.reloadData()
            }
        }
        
    }
    
    private func setupFloatingButton() {

        var bottomMargin: CGFloat = 0
        if let bottomSafeArea = SceneDelegate.shared?.window?.safeAreaInsets.bottom {
            bottomMargin = bottomSafeArea
        }
        
        self.flotingAddBtn = UIButton(frame: CGRect(x: self.view.frame.width - 80, y: self.view.frame.height - (80 + bottomMargin), width: 60, height: 60))
        self.flotingAddBtn.setImage(#imageLiteral(resourceName: "add"), for: .normal)
        self.flotingAddBtn.imageEdgeInsets = UIEdgeInsets (top: 10, left: 10, bottom: 10, right: 10)
        self.flotingAddBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.flotingAddBtn.cornerRadius = 30
        self.flotingAddBtn.enableShadow = true
        self.flotingAddBtn.layer.shadowColor = UIColor.black.cgColor
        self.flotingAddBtn.addTarget(self, action: #selector(floatingButton_Tapped), for: .touchUpInside)
        
        SceneDelegate.shared?.window?.addSubview(self.flotingAddBtn)
    }
    
    
    @objc func floatingButton_Tapped() {
        if let topviewController = navigationController?.topViewController {
          
            guard topviewController.isKind(of: AddMemberViewController.self) else {
                let main = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = main.instantiateViewController(withIdentifier: "AddMemberViewController") as! AddMemberViewController
                vc.isNewMember = true
                navigationController?.pushViewController(vc, animated: true)
                return
            }
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.view.resignFirstResponder()
    }
    
    @IBAction func Edit_Tapped(_ sender: UIButton) {
        guard let member = self.members?[sender.tag] else {
            return
        }
        
        let main = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = main.instantiateViewController(withIdentifier: "AddMemberViewController") as! AddMemberViewController
        vc.member = member
        vc.isNewMember = false
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else{
            guard let members = self.members else {
                return 0
            }
            return members.count
        }
        
        return self.firm == nil ? 0 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section == 0 else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemberProfileCell", for: indexPath) as! MemberProfileCell
            if let member = self.members?[indexPath.row] {
                cell.member = member
                cell.Edit_btn.tag = indexPath.row
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FirmProfileCell", for: indexPath) as! FirmProfileCell
        if let firm = self.firm {
            cell.Edit_btn.tag = self.isEditingFirm ? 1 : 0
            cell.vc = self
            cell.firm = firm
            cell.delegate = self
            cell.Firm_id.text = "ID : \((self.firmID ?? "0000").formaeID())"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        self.view.resignFirstResponder()
        self.Profile_tbl.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ProfileViewController : FirmProfileDelegate , AddMemberDelegate {
    func memberDidUpdated() {
        self.fetchProfile()
    }
    
    
    func newMemberAdded() {
        self.fetchProfile()
    }

    
    func needUpdateView(for editing: Bool) {
        self.isEditingFirm = editing
        self.Profile_tbl.reloadRows(at: [IndexPath (row: 0, section: 0)], with: .fade)
    }
    
    func needUpdateFirm(with data: [String : Any]) {
        
        hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        hud.vibrancyEnabled = true
        hud.textLabel.text = "Updating"
        hud.show(in: self.view, animated: true)
        print(data)
        APIManager.manager.updateFirm(for: data) { (success, error) in
            DispatchQueue.main.async {
                guard let error = error else {
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.textLabel.text = "Updated"
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                        self.isEditingFirm = false
                        self.fetchProfile()
                        
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
