//
//  ForgotPasswordViewController.swift
//  MBTA
//
//  Created by Ravi on 15/03/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit
import JGProgressHUD
class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    
    var hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Fill Email Details"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    
    @IBAction func Procced_Forgot(_ sender: UIButton) {
        
        hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        hud.vibrancyEnabled = true
        hud.textLabel.text = "Loading"
        hud.show(in: self.view, animated: true)
        
        guard self.email.text!.count > 0 else {
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.textLabel.text = "Empty Email Id"
            hud.dismiss(afterDelay: 1.0)
            return
        }
        
        APIManager.manager.forgotPassword(by: self.email.text!) { (success, error) in
            
            DispatchQueue.main.async {
                guard success else {
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.textLabel.text = "Invalid Email Id"
                    self.hud.dismiss(afterDelay: 1.0)
                    return
                }

                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.textLabel.text = "Sent Successfully "
                self.hud.dismiss(afterDelay: 2)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2.3) {
                        self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        
        
    }
    
}
