//
//  LogInViewController.swift
//  MBTA
//
//  Created by Ravi on 15/03/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit
import JGProgressHUD
import SideMenuSwift

class LogInViewController: UIViewController {

    @IBOutlet weak var UserID_text: UITextField!
    @IBOutlet weak var Password_text: UITextField!
    
    var hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func Login_Tapped(_ sender: UIButton) {
        
        hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        hud.vibrancyEnabled = true
        hud.textLabel.text = "Loading"
        hud.show(in: self.view, animated: true)
        
        guard self.UserID_text.text!.count > 0, self.Password_text.text!.count > 0 else {
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.textLabel.text = "Empty Credentials"
            hud.dismiss(afterDelay: 2.0)
            return
        }
        
        APIManager.manager.Login(userId: self.UserID_text.text!, password: self.Password_text.text!) { (success, error) in
            
            DispatchQueue.main.async {
                guard success else {
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.textLabel.text = "Wrong Id or Password"
                    self.hud.dismiss(afterDelay: 2.0)
                    return
                }
                
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.textLabel.text = "Logged In"
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
                    SceneDelegate.shared?.updateRoot()
                }
                self.hud.dismiss(afterDelay: 2)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func GuestSession_Tapped(_ sender: UIButton) {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = mainStoryboard.instantiateInitialViewController()
        SceneDelegate.shared?.window?.rootViewController = viewController
        SceneDelegate.shared?.window?.makeKeyAndVisible()
    }
    
    @IBAction func ForgotPassword_Tapped(_ sender: UIButton) {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
}
