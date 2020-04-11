//
//  SendNotificationController.swift
//  MBTA
//
//  Created by Ravi on 06/04/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit

class SendNotificationController: UIViewController {

    
    @IBOutlet weak var Member_btn: RadioButton!
    @IBOutlet weak var EveryOne_btn: RadioButton!
    @IBOutlet weak var Board_btn: RadioButton!
    
    @IBOutlet weak var Notification_title: UITextField!
    
    @IBOutlet weak var Notification_detail: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func Send_Tapped(_ sender: UIButton) {
    }
    

    @IBAction func EveryOne_Tapped(_ sender: UIButton) {
    }
    
}
