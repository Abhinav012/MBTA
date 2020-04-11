//
//  HistoryViewController.swift
//  MBTA
//
//  Created by Ravi on 06/04/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit
import WebKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var Web_view: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://www.techiveservices.com/Bullion_Association/Mbta/api/html/index-1.html")
        self.Web_view.load(URLRequest(url: url!))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard indexPath.row != 0 else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryInfoCell", for: indexPath) as! HistoryInfoCell
            
            
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryMemberCell", for: indexPath) as! HistoryMemberCell
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
