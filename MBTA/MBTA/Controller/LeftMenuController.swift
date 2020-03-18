//
//  LeftMenuViewController.swift
//  MBTA
//
//  Created by Ravi on 06/03/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit

class LeftMenuController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var User_Title_lbl: UILabel!
    @IBOutlet weak var MenuBar_Tableview: UITableView!
    
    var user : User?
    var isAuthenticated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MenuBar_Tableview.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard UserDefaults.standard.bool(forKey: "isAuthenticated") else {
            self.User_Title_lbl.text = "Guest"
            self.isAuthenticated = false
            self.MenuBar_Tableview.reloadData()
            return
        }
        
        if let data = UserDefaults.standard.value(forKey:"user@MBTA") as? Data {
            user = try? PropertyListDecoder().decode(User.self, from: data)
            self.User_Title_lbl.text = user?.f_name
        }
        self.isAuthenticated = true
        self.MenuBar_Tableview.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isAuthenticated ? 6 : 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuitemCell", for: indexPath)
        
        guard isAuthenticated else {
            
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Home"
                
            default:
                cell.textLabel?.text = "Login"
            }
            
            return cell
        }
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Export Directory"
            case 1:
            cell.textLabel?.text = "Edit Alert"
            case 2:
            cell.textLabel?.text = "Gold/Silver/Ginni Rate"
            case 3:
            cell.textLabel?.text = "Change Password"
            case 4:
            cell.textLabel?.text = "Notification"
            
        default:
            cell.textLabel?.text = "Logout"
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.textLabel?.text == "Logout" || cell?.textLabel?.text == "Login" {
            self.MovetoLogin()
        }
        
        sideMenuController?.hideMenu(animated: true, completion: nil)
    }
    
    func MovetoLogin() {
        
        UserDefaults.standard.set(false, forKey: "isAuthenticated")
        UserDefaults.standard.synchronize()
        SceneDelegate.shared?.updateRoot()
    
    }
}
