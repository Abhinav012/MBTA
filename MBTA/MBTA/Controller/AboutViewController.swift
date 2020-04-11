//
//  AboutViewController.swift
//  MBTA
//
//  Created by Ravi on 06/04/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit
import WebKit

class AboutViewController: UIViewController {

   @IBOutlet weak var Web_view: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://www.techiveservices.com/Bullion_Association/Mbta/api/html/about.html")
        self.Web_view.load(URLRequest(url: url!))
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
